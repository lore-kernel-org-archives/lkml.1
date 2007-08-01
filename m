Return-Path: <linux-kernel-owner+w=401wt.eu-S932238AbXHAAVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932238AbXHAAVy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 20:21:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759326AbXHAAVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 20:21:45 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:56920 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757300AbXHAAVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 20:21:44 -0400
Date: Tue, 31 Jul 2007 17:21:35 -0700 (PDT)
From: Zwane Mwaikambo <zwane@infradead.org>
Subject: Re: [PATCH] retrieve VBE EDID/DDC info independent of used video mode
In-reply-to: <46AFCCBB.70307@gentoo.org>
To: Daniel Drake <dsd@gentoo.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jan Beulich <jbeulich@novell.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>, "Antonino A. Daplas" <adaplas@pol.net>
Message-id: <Pine.LNX.4.64.0707311719540.5207@montezuma.windriver.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <4678191D.76E4.0078.0@novell.com> <4686D85B.6090803@gentoo.org>
 <20070630154230.4ad373fa.akpm@linux-foundation.org>
 <4690E65B.5050607@gentoo.org>
 <20070708111404.1486e73c.akpm@linux-foundation.org>
 <46912E09.2070806@zytor.com> <4692BC61.9070500@gentoo.org>
 <4692BDEE.8020802@zytor.com> <4693BF02.2050705@gentoo.org>
 <4693C0A1.8010901@zytor.com> <4693CAFF.4000609@gentoo.org>
 <4693CCC6.7050400@zytor.com> <46AFCCBB.70307@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On Tue, 31 Jul 2007, Daniel Drake wrote:

> Hi,
> 
> H. Peter Anvin wrote:
> > > So, 2.6.22-rc6-mm1 should work fine with CONFIG_FIRMWARE_EDID=y, or are
> > > further patches needed?
> > > 
> > 
> > It should, yes.
> 
> It didn't work, and the bug still exists in 2.6.23-rc1: the resolution is
> wrong by 6 pixels. The user does have CONFIG_FIRMWARE_EDID enabled.
> 
> So far the only known working setups since 2.6.20.11 are:
>  1. Zwane's patch reverted
>  2. Jan's patch applied (to 2.6.22 or lower, I guess it no longer works for
> 2.6.23)
> 
> Here is dmesg output from 2.6.23:
> http://bugs.gentoo.org/attachment.cgi?id=126203&action=view
> 
> Let me know how we can help diagnose this further.

Sorry if this has been hashed out before, but could you point me towards 
the gentoo bugzilla entry? I'm trying to understand how your setup broke. 
Which version VBE does your system have?

Thanks,
	Zwane

