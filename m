Return-Path: <linux-kernel-owner+w=401wt.eu-S1756813AbZHFVg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813AbZHFVg5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 17:36:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756787AbZHFVg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 17:36:56 -0400
Received: from outbound-mail-112.bluehost.com ([69.89.24.2]:37327 "HELO
	outbound-mail-112.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756776AbZHFVgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 17:36:55 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Aug 2009 17:36:55 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Pds8kISu/Y3J30ycyKknp7L4TnbNW3W55ZxlboSYQaSXacKBTFCUjzCr/puO1WqJ6U2l6CHQIoawgshbalusOj6DG1320W14tl5jjVIfjC1jV0yXMqxHIMFWPirAz3S2;
Date: Thu, 6 Aug 2009 14:30:12 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Alberto Gonzalez <alberto6674@gmail.com>
Cc: Michal Soltys <soltys@ziu.info>, Dave Airlie <airlied@linux.ie>,
       Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       linux-hotplug@vger.kernel.org
Subject: Re: Kernel 2.6.30 and udevd problem
Message-ID: <20090806143012.126b1595@jbarnes-g45>
In-Reply-To: <200908061553.23525.alberto6674@gmail.com>
References: <200906280821.58631.info@gnebu.es>
	<200907222200.21792.info@gnebu.es>
	<200907230206.36544.info@gnebu.es>
	<200908061553.23525.alberto6674@gmail.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Aug 2009 15:53:23 +0200
Alberto Gonzalez <alberto6674@gmail.com> wrote:

> On Thursday 23 July 2009 02:06:36 Alberto Gonzalez wrote:
> > > On Wednesday 22 July 2009 21:44:36 Jesse Barnes wrote:
> > > > Hm, so this type of interrupt problem is *supposed* to be
> > > > handled by setting of the PEG_BAND_GAP_DATA reg (low bits set
> > > > to 0xd).  Do you have that in your tree?  Does git master have
> > > > this problem?
> >
> > I've tested 2.6.31 from git and I can reproduce the problem.
> > Attached is the dmesg with the debug patch applied.
> >
> > > > Maybe we need to add a patch to 2.6.30.x to set
> > > > PEG_BAND_GAP_DATA as a workaround (git master already has code
> > > > to do this properly for HDMI and DP outputs afaict).
> 
> Hi,
> 
> No updates here? I was wondering if it would be more useful to open a
> bug report so that it doesn't get lost. It is a rather nasty bug that
> keeps me using .29 kernel, and since it seems to be clear where the
> problem is it seems a pity to let it go...

Yeah, sorry was on vacation.  A bug report would be great, can you
file one at bugs.freedesktop.org against drm/intel?  I think I know
where the issue might be, but I'll have to come up with some more test
patches for you.

-- 
Jesse Barnes, Intel Open Source Technology Center
