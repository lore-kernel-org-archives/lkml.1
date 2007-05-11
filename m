Return-Path: <linux-kernel-owner+w=401wt.eu-S966120AbXEKVmB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966120AbXEKVmB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 17:42:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758755AbXEKVll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 17:41:41 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:42635 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756142AbXEKVlk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 17:41:40 -0400
Date: Fri, 11 May 2007 23:33:40 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Jesper Juhl <jesper.juhl@gmail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, Heikki Orsila <shdl@zakalwe.fi>,
       Satyam Sharma <satyam.sharma@gmail.com>
Subject: Re: [PATCH] "volatile considered harmful", take 2
In-Reply-To: <46439284.6080901@zytor.com>
Message-ID: <Pine.LNX.4.61.0705112333320.9570@yvahk01.tjqt.qr>
References: <6143.1178828419@lwn.net> <Pine.LNX.4.61.0705102326470.6426@yvahk01.tjqt.qr>
 <46439284.6080901@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 10 2007 14:45, H. Peter Anvin wrote:
>Jan Engelhardt wrote:
>> On May 10 2007 14:20, Jonathan Corbet wrote:
>>> Who knew a documentation patch would get so many reviews?  I like it...
>> 
>> And the next thing is register-considered-harmful.txt. Running
>> 
>> 	grep -Pr '\bregister\s+(unsigned|char|short|int|long|float|
>> 	double|struct|union|uint|u\d+|s\d+)\b' linux-2.6.21/ | wc -l
>> 
>> turns up no less than 1106+2 hits.
>
>You forgot to exclude instances with "asm" in them.

You can do that.


	Jan
-- 
