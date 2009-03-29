Return-Path: <linux-kernel-owner+w=401wt.eu-S1757807AbZC2NDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757807AbZC2NDR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 09:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756416AbZC2NDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 09:03:00 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37365 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755364AbZC2NC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 09:02:59 -0400
Date: Sun, 29 Mar 2009 15:02:51 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: Artem Bityutskiy <dedekind@yandex.ru>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: replace() system call needed (was Re: EXT4-ish "fixes" in UBIFS)
Message-ID: <20090329130251.GF15492@elf.ucw.cz>
References: <49CCCB0A.6070701@nokia.com> <20090329122600.GA13737@elf.ucw.cz> <49CF6CBB.7070907@yandex.ru> <20090329124959.GD15492@elf.ucw.cz> <49CF70FD.7050802@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49CF70FD.7050802@nokia.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2009-03-29 16:00:45, Artem Bityutskiy wrote:
> Pavel Machek wrote:
>>>>> 2. create/write/rename leads to empty files
>>>> ..but this should not be. If we want to make that explicit, we should
>>>> provide "replace()" operation; where replace is rename that makes sure
>>>> that source file is completely on media before commiting the rename.
>>> Well, OK, we can fsync() before rename, we just need clean rules
>>> for this, so that all Linux FSes would follow them. Would be nice
>>> to have final agreement on all this stuff.
>>
>> My proposal is 
>>
>> rename() stays.
>
> It stays and:
>
> 1. does _not_ fsync

Does not fsync. If someone wants to make sure one of the files is on
the disk, he should use replace(). [On non-linux systems, replace()
should be implemented as fsync/rename in libc or something.]
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
