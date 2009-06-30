Return-Path: <linux-kernel-owner+w=401wt.eu-S1757626AbZF3VA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757626AbZF3VA4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 17:00:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753849AbZF3VAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 17:00:48 -0400
Received: from outbound-mail-108.bluehost.com ([69.89.22.8]:34185 "HELO
	outbound-mail-108.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753271AbZF3VAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 17:00:48 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=exjQ0QqzwLRh+3XnvTQPSCAsnngI8EQuqxnE+i7ZU2B2eErhFDufufZ+oCoCdTAmP9qFuaPG/Jv2RVcRGDQhfzmspFp6JRx4R1CFsNA1za9wxZVFlV8Mi85n19FpkvZQ;
Date: Tue, 30 Jun 2009 14:00:43 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Gary Hade <garyhade@us.ibm.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Matthew Wilcox <matthew@wil.cx>, "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] x86/pci: fix boundary checking when using root CRS
Message-ID: <20090630140043.1c9caa7a@jbarnes-g45>
In-Reply-To: <20090630180449.GA7183@us.ibm.com>
References: <20090624122433.GA24781@elte.hu>
	<20090624145119.GA12664@elte.hu>
	<4A429EBB.5010209@kernel.org>
	<4A42DA6F.2030305@kernel.org>
	<20090629181603.261ccd03@jbarnes-g45>
	<20090630180449.GA7183@us.ibm.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.17.2; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jun 2009 11:04:49 -0700
Gary Hade <garyhade@us.ibm.com> wrote:

> On Mon, Jun 29, 2009 at 06:16:03PM -0700, Jesse Barnes wrote:
> > On Wed, 24 Jun 2009 19:01:19 -0700
> > Yinghai Lu <yinghai@kernel.org> wrote:
> > 
> > > 
> > > don't touch info->res_num if we are out of space
> > > 
> > > Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> > 
> > Gary, any comments on these?
> 
> Jesse,
> "[PATCH 1/3] x86/pci: fix boundary checking when using root CRS"
> which convinced that my code was incorrect and
> "[PATCH 2/3] x86/pci: get root CRS before scan childs -v3"
> look good to me from both code review and functional [1] standpoints.
>   Acked-by: <garyhade@us.ibm.com>
>   Tested-by: <garyhade@us.ibm.com>
> 
> [1] Successful boot of patched 2.6.31-rc1 with pci=use_crs
>     followed by successful hot-add and hot-remove of PCI-X
>     and PCIe cards on an IBM x3850.
> 
> Thanks Yinghai.

Thanks guys, I've applied these to my for-linus branch for a pull later
this week.

-- 
Jesse Barnes, Intel Open Source Technology Center
