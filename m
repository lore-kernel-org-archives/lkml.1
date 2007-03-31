Return-Path: <linux-kernel-owner+w=401wt.eu-S1753095AbXCaOEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095AbXCaOEf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 10:04:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753096AbXCaOEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 10:04:34 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:39261 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753087AbXCaOEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 10:04:34 -0400
Date: Sat, 31 Mar 2007 16:04:32 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Toralf =?utf-8?Q?F=C3=B6rster?= <toralf.foerster@gmx.de>
Cc: Kyle Moffett <mrmacman_g4@mac.com>,
       Andrew Morton <akpm@linux-foundation.org>, Jiri Kosina <jikos@jikos.cz>,
       Lee Revell <rlrevell@joe-job.com>, andrea@suse.de,
       viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: fs/block_dev.c:953: warning: 'found' might be used uninitialized in this function
Message-ID: <20070331140432.GS14134@stusta.de>
References: <200703281847.05356.toralf.foerster@gmx.de> <46C1CD24-F48E-4EB9-B6A5-E1B3C303C62F@mac.com> <20070330194701.GL14134@stusta.de> <200703311011.32682.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200703311011.32682.toralf.foerster@gmx.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 31, 2007 at 10:11:27AM +0200, Toralf Förster wrote:
> Am Freitag, 30. März 2007 21:47 schrieb Adrian Bunk:
> > 
> > 
> > No, the code is correct and it's impossible that the variable ever gets 
> > read uninitialized.
> > 
> > And BTW, i386 gcc 4.1 doesn't give me a warning for this.
> > Toralf, which gcc version and architecture did you see this with?
> 
> > cu
> > Adrian
> > 
> 
> Hi, I use currently the following version:
> 
> gcc version 3.4.6 (Gentoo 3.4.6-r2, ssp-3.4.6-1.0, pie-8.7.10)

For finding warnings it's better to use the latest gcc version - gcc is 
evalving, and more recent versions tend to both give more valid warnings 
and give less warnings for non-problems (like in this case).

> MfG/Sincerely
> 
> Toralf Förster

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

