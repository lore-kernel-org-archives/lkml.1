Return-Path: <linux-kernel-owner+w=401wt.eu-S1760927AbXEZNmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760927AbXEZNmT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 09:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757348AbXEZNmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 09:42:08 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:56399 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757494AbXEZNmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 09:42:07 -0400
Date: Sat, 26 May 2007 15:41:16 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: David Miller <davem@davemloft.net>
cc: satyam.sharma@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: double exclamation (!!) suckage in the kernel
In-Reply-To: <20070525.141421.73699719.davem@davemloft.net>
Message-ID: <Pine.LNX.4.61.0705261535240.7344@yvahk01.tjqt.qr>
References: <a781481a0705251323s6b5c8014t48e8d2ad63e8434a@mail.gmail.com>
 <20070525.141421.73699719.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 25 2007 14:14, David Miller wrote:
>
>WHat is with multiple people asking about "!!" all of a
>sudden today?
>
>> Are all these occurrences merely the debris of
>> s/something/!notsomething/g kind of patches or is there some
>> dark, unknown C / gcc wizardry I have absolutely no clue of?
>
>"!!" is used in contexts where pointers might be being
>tested as well as plain integers, the "!!" turns a pointer
>into the equivalent integer boolean for testing.
>
>NULL pointers become 0
>non-NULL pointers become 1

Though,
	if(!!ptr)
is effectively the same as
	if(ptr)

!! is mostly used where non-zero values need to be mapped to 1.
Not so much in logic expressions (if,while,etc.) but in arithmetic
(who'd do that?).

	Jan
-- 
