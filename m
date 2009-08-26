Return-Path: <linux-kernel-owner+w=401wt.eu-S932621AbZHZAcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932621AbZHZAcQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 20:32:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755745AbZHZAcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 20:32:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54683 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755691AbZHZAcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 20:32:14 -0400
Message-ID: <4A948259.40007@redhat.com>
Date: Tue, 25 Aug 2009 20:31:21 -0400
From: Ric Wheeler <rwheeler@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Theodore Tso <tytso@mit.edu>, Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>, Rob Landley <rob@landley.net>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, corbet@lwn.net
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
 possible
References: <20090825094244.GC15563@elf.ucw.cz> <4A93E908.6050908@redhat.com> <20090825211515.GA3688@elf.ucw.cz> <4A9468E8.607@redhat.com> <20090825225114.GE4300@elf.ucw.cz> <4A946DD1.8090906@redhat.com> <20090825232601.GF4300@elf.ucw.cz> <4A947682.2010204@redhat.com> <20090825235359.GJ4300@elf.ucw.cz> <4A947DA9.2080906@redhat.com> <20090826001645.GN4300@elf.ucw.cz>
In-Reply-To: <20090826001645.GN4300@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/2009 08:16 PM, Pavel Machek wrote:
> On Tue 2009-08-25 20:11:21, Ric Wheeler wrote:
>> On 08/25/2009 07:53 PM, Pavel Machek wrote:
>>>> Why don't you hold all of your most precious data on that single S-ATA
>>>> drive for five year on one box and put a second copy on a small RAID5
>>>> with ext3 for the same period?
>>>>
>>>> Repeat experiment until you get up to something like google scale or the
>>>> other papers on failures in national labs in the US and then we can have
>>>> an informed discussion.
>>>
>>> I'm not interested in discussing statistics with you. I'd rather discuss
>>> fsync() and storage design issues.
>>>
>>> ext3 is designed to work on single SATA disks, and it is not designed
>>> to work on flash cards/degraded MD RAID5s, as Ted acknowledged.
>>
>> You are simply incorrect, Ted did not say that ext3 does not work
>> with MD raid5.
>
> http://lkml.org/lkml/2009/8/25/312
> 									Pavel

I will let Ted clarify his text on his own, but the quoted text says "... have 
potential...".

Why not ask Neil if he designed MD to not work properly with ext3?

Ric

