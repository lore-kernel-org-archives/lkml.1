Return-Path: <linux-kernel-owner+w=401wt.eu-S1752670AbXC3TkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670AbXC3TkO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 15:40:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752350AbXC3TkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 15:40:14 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:38807 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752670AbXC3TkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 15:40:11 -0400
Date: Fri, 30 Mar 2007 21:40:11 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Lee Revell <rlrevell@joe-job.com>
Cc: Toralf =?utf-8?Q?F=C3=B6rster?= <toralf.foerster@gmx.de>, andrea@suse.de,
       viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: fs/block_dev.c:953: warning: 'found' might be used uninitialized in this function
Message-ID: <20070330194011.GK14134@stusta.de>
References: <200703281847.05356.toralf.foerster@gmx.de> <75b66ecd0703280956i522cf6cbyc4c9ef8b1666ec15@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <75b66ecd0703280956i522cf6cbyc4c9ef8b1666ec15@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2007 at 12:56:59PM -0400, Lee Revell wrote:
> On 3/28/07, Toralf Förster <toralf.foerster@gmx.de> wrote:
> >I compiled current git source 2.6.21-rc5-g28defbe and got this warning:
> >...
> >fs/block_dev.c: In function `bd_claim_by_kobject':
> >fs/block_dev.c:953: warning: 'found' might be used uninitialized in this 
> >function
> >...
> >
> 
> Most of these warnings are really GCC bugs.  Please examine the code
> in question.

The word "GCC bugs" is a bit hard for them.

gcc gives different warnings for code where it could prove that a 
variable gets used uninitialized and code where it's not sure whether a 
variable will always be used initialized.

There are even cases where it's technically impossible for gcc to 
determine that a variable always gets initialized.

And these "might be used uninitialized" warnings have already found 
several kernel bugs.

> Lee

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

