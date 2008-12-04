Return-Path: <linux-kernel-owner+w=401wt.eu-S1758812AbYLDTDz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758812AbYLDTDz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 14:03:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755618AbYLDTDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 14:03:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41346 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755554AbYLDTDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 14:03:45 -0500
Message-ID: <49382973.4000908@zytor.com>
Date: Thu, 04 Dec 2008 11:03:15 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: Theodore Tso <tytso@mit.edu>, kernel list <linux-kernel@vger.kernel.org>
Subject: Re: SD/MMC cards: how crappy they are?
References: <20081202144830.GB1549@ucw.cz> <493562A5.40308@zytor.com> <20081202165608.GD18162@mit.edu> <4935778E.1020405@zytor.com> <20081204103206.GD22396@elf.ucw.cz>
In-Reply-To: <20081204103206.GD22396@elf.ucw.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
>>>
>> I have seen flash cards die permanently from having a partition table it
>> didn't like written to it.  Yes, the microcontroller on the flash card
>> tried to interpret the partition table, assumed to be MS-DOS style, and
>> would crash.
> 
> Aha... that explains why I killed few flashcards by tar xzvf /dev/sdX files
> ... hopefully thats fixed in the better/bigger cards now.
> 

Also had a batch of cards which would silently "correct" the partition
table for you to align the partitions to its flash erase blocks.

	-hpa
