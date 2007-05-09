Return-Path: <linux-kernel-owner+w=401wt.eu-S1758024AbXEILLF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758024AbXEILLF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 07:11:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756041AbXEILKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 07:10:55 -0400
Received: from dtp.xs4all.nl ([80.126.206.180]:19864 "HELO abra2.bitwizard.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751615AbXEILKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 07:10:54 -0400
Date: Wed, 9 May 2007 13:10:49 +0200
From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
To: Satyam Sharma <satyam.sharma@gmail.com>
Cc: Rogier Wolff <R.E.Wolff@BitWizard.nl>, linux-kernel@vger.kernel.org
Subject: Re: nbd problem.
Message-ID: <20070509111049.GA2362@bitwizard.nl>
References: <20070508194053.GA23615@bitwizard.nl> <a781481a0705081333u7b910522x5aac0a0e532d5f85@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a781481a0705081333u7b910522x5aac0a0e532d5f85@mail.gmail.com>
Organization: BitWizard.nl
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2007 at 01:33:52PM -0700, Satyam Sharma wrote:
> On 5/8/07, Rogier Wolff <R.E.Wolff@bitwizard.nl> wrote:
> >
> >Hi,
> >
> >The nbd client still reliably hangs when I use it.

Someone suggested to use 

http://git.kernel.org/?p=linux/kernel/git/axboe/linux-2.6-block.git;a=summary

and that fixed it.  (i.e. there is something in there that should
be merged....)

Jens, thanks for pointing out that there were different locks 
involved.

	Roger. 

(I seem to have lost all other EMails in this thread. Apparently
my delete-old-list-emails is too agressive today...)

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
