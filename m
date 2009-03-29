Return-Path: <linux-kernel-owner+w=401wt.eu-S1756485AbZC2NGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756485AbZC2NGu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 09:06:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753525AbZC2NGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 09:06:41 -0400
Received: from smtp.nokia.com ([192.100.105.134]:23866 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbZC2NGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 09:06:40 -0400
Message-ID: <49CF7254.8030408@nokia.com>
Date: Sun, 29 Mar 2009 16:06:28 +0300
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
Organization: Nokia OYJ
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>
CC: Artem Bityutskiy <dedekind@yandex.ru>, Pavel Machek <pavel@ucw.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: replace() system call needed (was Re: EXT4-ish "fixes" in UBIFS)
References: <49CCCB0A.6070701@nokia.com> <20090329122600.GA13737@elf.ucw.cz> <49CF6CBB.7070907@yandex.ru> <49CF7120.4090503@ursus.ath.cx>
In-Reply-To: <49CF7120.4090503@ursus.ath.cx>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 29 Mar 2009 13:06:29.0703 (UTC) FILETIME=[2CD8BD70:01C9B06F]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ext Andreas T.Auer wrote:
> 
> On 29.03.2009 14:42 Artem Bityutskiy wrote:
>> Pavel Machek wrote:
>>
>>>> 1. truncate/write/close leads to empty files
>>> this is buggy.
>> In FS, or in application?
> In application of course. If you rewrite a huge file that way, you have
> a long-time risk of loosing data in a crash, even with sychronous writes.

You know, after reading all these blogs and discussions,
I will not be surprised if someone says this is an FS bug.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
