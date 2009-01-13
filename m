Return-Path: <linux-kernel-owner+w=401wt.eu-S1760072AbZAMG0F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760072AbZAMG0F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 01:26:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754200AbZAMGZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 01:25:55 -0500
Received: from an-out-0708.google.com ([209.85.132.242]:61872 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754541AbZAMGZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 01:25:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=VwfHL600Pi/qK2OX7LIBrND+kV6f7Naxm4wFLyZB+l+gzRd1uiCbzYwnlL9IwyrD0R
         9z+5qAnwM+J19dJ7hHJChcqerqilLz0wRPBo66GTFd52npxKsxv9Lgev8qoKu1MvGbhK
         OKCWOFW195pF72gEQlM8Rj3c0rpNataV1EmuM=
Date: Mon, 12 Jan 2009 22:25:14 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Richard Purdie <rpurdie@linux.intel.com>
Cc: Valdis.Kletnieks@vt.edu, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.29-mmotm0109 Odd prompt for Sharp Corgi backlight.
Message-ID: <20090112222422.ZZRA012@mailhub.coreip.homeip.net>
References: <67095.1231699127@turing-police.cc.vt.edu> <1231718399.5304.62.camel@dax.rpnet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231718399.5304.62.camel@dax.rpnet.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 11, 2009 at 11:59:59PM +0000, Richard Purdie wrote:
> On Sun, 2009-01-11 at 13:38 -0500, Valdis.Kletnieks@vt.edu wrote:
> > So I'm building mmotm-0109, doing a 'make oldconfig', and out pops:
> > 
> >     Generic (aka Sharp Corgi) Backlight Driver (BACKLIGHT_GENERIC) [Y/n/m/?] (NEW) ?
> > 
> > Say y to enable the generic platform backlight driver previously
> > known as the Corgi backlight driver. If you have a Sharp Zaurus
> > SL-C7xx, SL-Cxx00 or SL-6000x say y.
> > 
> > 
> > Two questions:
> > 
> > 1) Is it a Corgi driver, or truly a generic one?  It can't be *too* generic
> > if it only applies to 3 Sharp Zaurus models?  Or do I want to specify it for
> > my Dell laptop that has a backlight too (in which case that help text needs
> > fixing)...
> 
> It is truly generic code now. Your Dell laptop won't use it but it won't
> hurt it either.
> 
> > 2) Why does this default to 'Y'? (Probably depends on the answer to (1) - if
> > it's for one vendor, it probably should be N, but Y may make sense if it's
> > proper for the vast majority of all laptops and similar that have a backlight.
> 
> It defaults to Y since its harmless if not used and will become the
> common case for a large number of devices.
> 

While lots of the drivers are harmless if not used the dafault ofr them
is still N. Can we add some arch dependency or something?

-- 
Dmitry
