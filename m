Return-Path: <linux-kernel-owner+w=401wt.eu-S1756167AbZC2NBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167AbZC2NBP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 09:01:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754569AbZC2NA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 09:00:58 -0400
Received: from smtp.nokia.com ([192.100.105.134]:23723 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753606AbZC2NA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 09:00:57 -0400
Message-ID: <49CF70FD.7050802@nokia.com>
Date: Sun, 29 Mar 2009 16:00:45 +0300
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
Organization: Nokia OYJ
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Artem Bityutskiy <dedekind@yandex.ru>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: replace() system call needed (was Re: EXT4-ish "fixes" in	UBIFS)
References: <49CCCB0A.6070701@nokia.com> <20090329122600.GA13737@elf.ucw.cz> <49CF6CBB.7070907@yandex.ru> <20090329124959.GD15492@elf.ucw.cz>
In-Reply-To: <20090329124959.GD15492@elf.ucw.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 29 Mar 2009 13:00:47.0447 (UTC) FILETIME=[60D89E70:01C9B06E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
>>>> 2. create/write/rename leads to empty files
>>> ..but this should not be. If we want to make that explicit, we should
>>> provide "replace()" operation; where replace is rename that makes sure
>>> that source file is completely on media before commiting the rename.
>> Well, OK, we can fsync() before rename, we just need clean rules
>> for this, so that all Linux FSes would follow them. Would be nice
>> to have final agreement on all this stuff.
> 
> My proposal is 
> 
> rename() stays.

It stays and:

1. does _not_ fsync
2. has synchronous fsync added
3. stays and have asynchronous fsync added?

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
