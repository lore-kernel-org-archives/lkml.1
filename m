Return-Path: <linux-kernel-owner+w=401wt.eu-S933585AbXBXW6L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933585AbXBXW6L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 17:58:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933584AbXBXW6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 17:58:10 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:45881 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933585AbXBXW6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 17:58:08 -0500
Date: Sat, 24 Feb 2007 23:55:28 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: dsaxena@plexity.net, Linus Torvalds <torvalds@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Allow kernel to build on Cygwin
In-Reply-To: <45DF842F.9000302@zytor.com>
Message-ID: <Pine.LNX.4.61.0702242354550.16527@yvahk01.tjqt.qr>
References: <20070223034343.GA3320@plexity.net> <45DF842F.9000302@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 23 2007 16:17, H. Peter Anvin wrote:
> Deepak Saxena wrote:
>> 
>> diff --git a/lib/gen_crc32table.c b/lib/gen_crc32table.c
>> index bea5d97..ce447ff 100644
>> --- a/lib/gen_crc32table.c
>> +++ b/lib/gen_crc32table.c
>> @@ -1,6 +1,8 @@
>> # include <stdio.h>
>> # include "crc32defs.h"
>> +#ifndef __CYGWIN__
>> #include <inttypes.h>
>> +#endif
>> 
>> #define ENTRIES_PER_LINE 4
>
> Cygwin has <inttypes.h> just fine; what are you trying to do here?

What's the benefit of inttypes.h over stdint.h?


Jan
-- 
ft: http://freshmeat.net/p/chaostables/
