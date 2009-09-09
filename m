Return-Path: <linux-kernel-owner+w=401wt.eu-S1752832AbZIIJS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832AbZIIJS1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 05:18:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752792AbZIIJS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 05:18:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56782 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795AbZIIJSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 05:18:25 -0400
Message-ID: <4AA73309.8030302@zytor.com>
Date: Tue, 08 Sep 2009 21:46:01 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: LKML <linux-kernel@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH RFC] char/tty_io: fix legacy pty name when more than 256
 pty devices are requested
References: <20090908144942.76ddf0e7@caramujo.chehab.org>	<4AA6DF50.3030603@zytor.com>	<20090908203323.486c129c@caramujo.chehab.org>	<4AA6F63F.7090009@zytor.com> <20090908235441.04549a29@caramujo.chehab.org>
In-Reply-To: <20090908235441.04549a29@caramujo.chehab.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/2009 07:54 PM, Mauro Carvalho Chehab wrote:
>>
>> IMO, no less weird than a random shift from one naming algorithm to
>> another in the middle of the sequence.
> 
> Ok, your algorithm will be fully compatible with the old naming system, as
> you're encoding the nibbles on this order:
> 	[7:4][3:0][*:8]
> 

Actually it's [7:4][*:8][3:0].  It was the easiest way to get backwards
compatibility, since it allowed for the use of s[n]printf().  It's not
by any means the only possibility, but I think the easiest one to describe.

> From one side, I liked the idea of not having any arbitrary maximum limit, but
> from other side, It seems easier to implement than to describe it in English,
> at devices.txt. Maybe the solution is to explain it by examples.
> 
> Also, if we look at the current device designation, we already have some rule
> changes. 

That doesn't mean it's a good idea.


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

