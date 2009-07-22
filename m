Return-Path: <linux-kernel-owner+w=401wt.eu-S1754308AbZGVTok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308AbZGVTok (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 15:44:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754089AbZGVToj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 15:44:39 -0400
Received: from outbound-mail-312.bluehost.com ([67.222.54.5]:38697 "HELO
	outbound-mail-312.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754004AbZGVToj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 15:44:39 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=BABQVFhQCD/+nDH4vuTqEbeUPYcwiJ1K3i++Asz4DTOTpWFh0qEGy2BVas5ClnuPoSLJTN6CeMpqH6wLohvL2IQ+cTujcx2y/BBwzHAZ9o0zBXur10AyxAdXFtxUottN;
Date: Wed, 22 Jul 2009 12:44:36 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Alberto Gonzalez <alberto6674@gmail.com>
Cc: Michal Soltys <soltys@ziu.info>, Dave Airlie <airlied@linux.ie>,
       Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       linux-hotplug@vger.kernel.org
Subject: Re: Kernel 2.6.30 and udevd problem
Message-ID: <20090722124436.0daa2079@jbarnes-g45>
In-Reply-To: <200907222043.57244.info@gnebu.es>
References: <200906280821.58631.info@gnebu.es>
	<200907221851.20916.info@gnebu.es>
	<20090722101251.0b6c7300@jbarnes-g45>
	<200907222043.57244.info@gnebu.es>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jul 2009 20:43:56 +0200
Alberto Gonzalez <alberto6674@gmail.com> wrote:

> On Wednesday 22 July 2009 19:12:51 Jesse Barnes wrote:
> > Ah I must have been looking at the wrong register.  This one makes
> > it look like one of your HDMI hotplug bits is getting stuck (HDMIC
> > in particular).  This might not even be wired up on your platform...
> 
> Yes, I don't use HDMI, my screen is attached via VGA
> >
> > This test hack should prevent us from responding to those
> > interrupts...
> 
> I've been hitting it hard for over an hour with all the usual tricks
> to trigger it (and a few reboots) and I've been unable to reproduce
> the problem with this patch. Before I could trigger it reliably in a
> few minutes, so I'm pretty sure this patch fixes it. If something new
> comes up, I'll let you know anyway.

Hm, so this type of interrupt problem is *supposed* to be handled by
setting of the PEG_BAND_GAP_DATA reg (low bits set to 0xd).  Do you
have that in your tree?  Does git master have this problem?

Maybe we need to add a patch to 2.6.30.x to set PEG_BAND_GAP_DATA as a
workaround (git master already has code to do this properly for HDMI
and DP outputs afaict).

-- 
Jesse Barnes, Intel Open Source Technology Center
