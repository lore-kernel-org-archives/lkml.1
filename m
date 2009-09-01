Return-Path: <linux-kernel-owner+w=401wt.eu-S1753974AbZIAUFO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974AbZIAUFO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 16:05:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752895AbZIAUFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 16:05:13 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49671 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbZIAUFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 16:05:12 -0400
Date: Tue, 1 Sep 2009 15:37:37 +0200
From: Pavel Machek <pavel@ucw.cz>
To: jim owens <jowens@hp.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
       Greg Freemyer <greg.freemyer@gmail.com>, linux-kernel@vger.kernel.org,
       linux-doc@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: Data integrity built into the storage stack
Message-ID: <20090901133737.GA1852@ucw.cz>
References: <87f94c370908291423ub92922ft2cceab9e34ac6207@mail.gmail.com> <yq1hbvntf62.fsf@sermon.lab.mkp.net> <20090901124403.GC1371@ucw.cz> <4A9D1F0F.9050802@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A9D1F0F.9050802@hp.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-09-01 09:18:07, jim owens wrote:
> Pavel Machek wrote:
>> Hi!
>>
>>> I do agree that we do have to be more prepared for collateral damage
>>> scenarios.  As we discussed at LS we have 4KB drives coming out that can
>>> invalidate previously acknowledged I/Os if it gets a subsequent write
>>> failure on a sector.  And there's also the issue of fractured writes
>>
>> Hmmm, future will be interesting.
>>
>> 'ext3 expects disks to behave like disks from 1995' (alarming).
>
> NO... stop saying "ext3".  All file systems expect that
> what the disk tell us is the "sector size" (now know by
> disk vendors as "block size") is "atomic".

Yep, but ext3 disables barriers by default. So it has more than
blocksize issue :-(.
							Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
