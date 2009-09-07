Return-Path: <linux-kernel-owner+w=401wt.eu-S1758716AbZIGCvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758716AbZIGCvP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 22:51:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758590AbZIGCvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 22:51:15 -0400
Received: from mail.gmx.net ([213.165.64.20]:44614 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758528AbZIGCvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 22:51:14 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX19ntYd8nq1n5Wt3b26Dwg0s86CaDmZqZ/962NsM8W
	7QptKt0Bf6HwOV
Message-ID: <4AA47514.8080801@gmx.de>
Date: Mon, 07 Sep 2009 04:51:00 +0200
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: Andrew Morton <akpm@linux-foundation.org>, JosephChan@via.com.tw,
       ScottFang@viatech.com.cn, linux-fbdev-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [Linux-fbdev-devel] [PATCH v2] viafb: 2D engine rewrite (and
 viafb patches in general)
References: <1251666438-5448-1-git-send-email-FlorianSchandinat@gmx.de>	<1252097032-3568-1-git-send-email-FlorianSchandinat@gmx.de>	<20090905161645.74a49a84@bike.lwn.net>	<20090905160140.7b36527f.akpm@linux-foundation.org>	<4AA3048D.2090605@gmx.de> <20090906074002.7976d4a5@bike.lwn.net>
In-Reply-To: <20090906074002.7976d4a5@bike.lwn.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.59
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Corbet schrieb:
>> Do you have a pointer to the OLPC tree?
> 
> git://dev.laptop.org/olpc-2.6
> 
> They are working in the olpc-2.6.30 branch, currently.

Thanks. After having a look at it seems concerning viafb to be mostly 
Haralds patches with 1 or 2 extra ones.

>> I'd really like to see VX855/OLPC support in mainline as soon as 
>> possible as I consider it a good thing to support "new" hardware early. 
>> However even if I am capable to write such support based on Haralds work 
>> I don't want to see it in mainline as long as no one with that hardware 
>> tested it.
> 
> I do have the hardware, and I've taken on the responsibility for making
> pieces of it work.  In my mind, that includes being responsible for
> mainlining things too.  I will start to work in that direction; 2.6.33
> should be a reasonable target for the bulk of it.
> 
> My thinking, FWIW, is to turn the viafb code into something more like a
> regular multi-function device driver.  I've already integrated Harald's i2c
> stuff with the OLPC code; I need to add proper GPIO support next.  Then
> there will be the V4L2 chunk for the video capture engine.  Along the way,
> I may try to introduce some foreign concepts like locking.

Feel free to add the things you like. The main objective is probably to 
get things working and stable. I do not have an idea how good that will 
work out as I don't know how much code that requires. If you think 
that's the way to go, then we'll try it and see whether it leads to 
something usable and maintainable.

> I have a tree on git.lwn.net now, but it's against the 2.6.30 base.  I will
> try to bring things forward to a more current tree sometime soon and put it
> up as, at least, a place where we can see the various lines of development
> going on.
> 
> Sound good?

Jep, that's fine with me. I'll try to rebase&integrate the patches I 
consider interesting from Harald's tree in -mm. I guess that's a good 
thing to do as that's the latest used common base.
Any objections?


Regards,

Florian Tobias Schandinat
