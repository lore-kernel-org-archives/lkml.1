Return-Path: <linux-kernel-owner+w=401wt.eu-S1752885AbXDBRzE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885AbXDBRzE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 13:55:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965554AbXDBRzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 13:55:04 -0400
Received: from vms044pub.verizon.net ([206.46.252.44]:52316 "EHLO
	vms044pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885AbXDBRzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 13:55:01 -0400
Date: Mon, 02 Apr 2007 13:54:28 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: mmap error?
In-reply-to: <20070402173544.GA19343@deepthought>
To: linux-kernel@vger.kernel.org
Message-id: <200704021354.32636.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200704021030.29747.gene.heskett@gmail.com>
 <20070402173544.GA19343@deepthought>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 April 2007, Ken Moffat wrote:
>Hi Gene,
>
>On Mon, Apr 02, 2007 at 10:30:29AM -0400, Gene Heskett wrote:
>> Greetings all;
>>
>> Has something been changed recently, say post 2.6.19, that would
>> effect this error from k3b when I click start (the burn), with a fresh
>> dvd+r in the drive:
>>
>> --------
>> Using growisofs 7.0 Copyright (C) Andy Polyakov <appro@fy.chalmers.se>
>> Starting writing...
>>
>> :-( unable to anonymously mmap 33554432; resource temporarily
>>
>> unavailable...
>> Fatal error at startup, resource temporarily unavailable...
>> --------
>
> Known problem, please see
>http://fy.chalmers.se/~appro/linux/DVD+RW/tools/ (third paragraph)
>for a workaround.
>
Ahh, thank you very much.  But I have 7.0, supposedly fixed, sigh...  That 
did fix it, the dvd is burning as I type, again thanks.

???? Can I put this into rc.local so its global?  I guess I will just for 
effects.  Or is there an option in a make xconfig to reset this to a 
usable sized limit?, because I can see cups also having problems since I 
have its render cache set for 127 megs, which should also trigger this.

Seems like a 'what were they thinking moment' to me. :)

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
purpitation, n.:
	To take something off the grocery shelf, decide you
	don't want it, and then put it in another section.
		-- "Sniglets", Rich Hall & Friends
