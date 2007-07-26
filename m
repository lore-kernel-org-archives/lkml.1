Return-Path: <linux-kernel-owner+w=401wt.eu-S934184AbXGZQ5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934184AbXGZQ5j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 12:57:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761606AbXGZQ53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 12:57:29 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:45729 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757947AbXGZQ52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 12:57:28 -0400
Date: Thu, 26 Jul 2007 18:57:01 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Kyle Rose <krose@akamai.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: sk98lin for 2.6.23-rc1
Message-ID: <20070726165701.GM3572@stusta.de>
References: <46A8BAD4.8020004@akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <46A8BAD4.8020004@akamai.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2007 at 11:16:36AM -0400, Kyle Rose wrote:
> >From http://www.krose.org/~krose/computing.html:
> 
> Since the sky2 driver continues to suck ass (which is a technical
> description for "it hangs all the time under load, at least on my
> hardware" :-) ), I've fixed the sk98lin driver to compile for
> linux-2.6.23-rc1. Those who continue to have problems with sky2 can
> still use 2.6.23-rc1, simply by doing the following:
>...
> Personally, I'd like to see sk98lin remain in the kernel proper until
> sky2 goes at least 6 months without reported problems.  The fact that I
> am not the only one still seeing issues is a clear indication that sky2
> (even with the recent patches in 2.6.23-rc1) is not yet ready to replace
> sk98lin.
>...

This sounds good in theory.

The practical problem with this approach is that there are always many 
people who use the old driver when the new driver doesn't work for them 
instead of reporting their problems with the new driver.

For these people a new driver will often suck when the old driver gets 
removed, but after the removal of the old driver they are finally forced 
to report their bugs resulting in a better new driver for everyone.

The sky2 driver is since nearly 2 years in the kernel and Stephen is 
usually quite good at handling bugs.

> Kyle

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

