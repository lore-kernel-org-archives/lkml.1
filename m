Return-Path: <linux-kernel-owner+w=401wt.eu-S970887AbXILRMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970887AbXILRMy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 13:12:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765617AbXILRMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 13:12:46 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:59414 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764493AbXILRMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 13:12:45 -0400
Date: Wed, 12 Sep 2007 19:12:53 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>, Greg KH <gregkh@suse.de>,
       Toralf =?utf-8?Q?F=C3=B6rster?= <toralf.foerster@gmx.de>,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: 2.6.23-rc6: known regressions with patches
Message-ID: <20070912171253.GB3563@stusta.de>
References: <46E81AE2.8030802@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <46E81AE2.8030802@googlemail.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2007 at 06:59:14PM +0200, Michal Piotrowski wrote:
> Hi all,
> 
> Here is a list of some known regressions in 2.6.23-rc6
> with patches available.
>...
> MTD
> 
> Subject         : include/linux/mtd/map.h:128:2: error: #error "No bus width supported. What's the point?"
> References      : http://lkml.org/lkml/2007/9/11/151
> Last known good : ?
> Submitter       : Toralf Förster <toralf.foerster@gmx.de>
> Caused-By       : ?
> Handled-By      : ?
> Patch           : http://git.infradead.org/?p=mtd-2.6.git;a=commit;h=241651d04d672fb685b2874707016cbbf95931e5
> Status          : patch available

Not a regression, and simply a pointless configuration.

>...
> USB
> 
> Subject         : build #246 failed for 2.6.23-rc6-g0d4cbb5 in linux/drivers/usb/misc/phidgetservo.ko
> References      : http://lkml.org/lkml/2007/9/11/211
> Last known good : ?
> Submitter       : Toralf Förster <toralf.foerster@gmx.de>
> Caused-By       : ?
> Handled-By      : Adrian Bunk <bunk@kernel.org>
> Patch           : http://lkml.org/lkml/2007/9/11/284
> Status          : patch available

Not a 2.6.23-rc regression (but IMHO the patch should be safe enough 
for 2.6.23).

> Regards,
> Michal

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

