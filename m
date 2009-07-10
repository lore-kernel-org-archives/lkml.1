Return-Path: <linux-kernel-owner+w=401wt.eu-S1753255AbZGJHhQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255AbZGJHhQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 03:37:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751541AbZGJHhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 03:37:04 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53590 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbZGJHhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 03:37:03 -0400
Date: Fri, 10 Jul 2009 09:36:55 +0200
From: Pavel Machek <pavel@ucw.cz>
To: tridge@samba.org
Cc: Martin Steigerwald <Martin@lichtvoll.de>,
       Jan Engelhardt <jengelh@medozas.de>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Theodore Tso <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>, john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org, James.Bottomley@hansenpartnership.com
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
Message-ID: <20090710073654.GB28106@elf.ucw.cz>
References: <19013.8005.541836.436991@samba.org> <200907072356.51553.Martin@lichtvoll.de> <19028.3736.892828.352905@samba.org> <200907081339.59815.Martin@lichtvoll.de> <19029.28240.995268.850038@samba.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19029.28240.995268.850038@samba.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-07-09 14:13:04, tridge@samba.org wrote:
> Hi Martin,
> 
>  > The question before that would be whether anyone has a comprehensive list 
>  > of those tools, cause I think there are quite many. Well at least those 
>  > from bigger vendors should be tested I think. Paragon, Symantec, ...
> 
> Do you happen to have any of those handy to test with?
> 
>  > And has it been tested with Linux tools such as fsck.msdos, fsck.vfat, 
>  > parted and partimage? I think it probably has not much effect on parted and 
>  > partimage, but what about the fscks?
> 
> I tested it with dosfstools (which provides the fsck.vfat on Linux
> distros) and with mtools. Both required patches to work correctly. I
> have submitted both patches to the maintainers of those packages.

Yes... so we know that your patch breaks at least

98 (completely)
XP (randomly)
mp3 players (completely)
cameras (workaround possible)
linux (patches available).

I believe my suggested help text was very fair.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
