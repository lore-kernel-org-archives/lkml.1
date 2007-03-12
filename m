Return-Path: <linux-kernel-owner+w=401wt.eu-S932065AbXCLBdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932065AbXCLBdj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 21:33:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751796AbXCLBdj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 21:33:39 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:33176 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751744AbXCLBdi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 21:33:38 -0400
Date: Mon, 12 Mar 2007 02:32:00 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Kyle Moffett <mrmacman_g4@mac.com>
cc: Daniel Hazelton <dhazelton@enter.net>,
       Cong WANG <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Style Question
In-Reply-To: <333D1A52-915E-4D08-8E7E-7FBB23EC6357@mac.com>
Message-ID: <Pine.LNX.4.61.0703120229030.18623@yvahk01.tjqt.qr>
References: <2375c9f90703110715v4278f83flbc9fce6c542472a5@mail.gmail.com>
 <Pine.LNX.4.61.0703112134180.16857@yvahk01.tjqt.qr> <200703111641.52066.dhazelton@enter.net>
 <14DE5DBD-4164-4CDF-9690-631514EB15EF@mac.com> <Pine.LNX.4.61.0703120015390.18623@yvahk01.tjqt.qr>
 <333D1A52-915E-4D08-8E7E-7FBB23EC6357@mac.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 11 2007 21:27, Kyle Moffett wrote:
> On Mar 11, 2007, at 19:16:59, Jan Engelhardt wrote:
>> On Mar 11 2007 18:01, Kyle Moffett wrote:
>> > On the other hand when __cplusplus is defined they define it to the
>> > "__null" builtin, which GCC uses to give type conversion errors for
>> > "int foo = NULL" but not "char *foo = NULL".

>> I think that the primary reason they use __null is so that you can
>> actually do[...]
>
> Isn't that what I said? :-D

Ya. Though I was picking at

|"__null" builtin, which GCC uses to give type conversion errors for
|"int foo = NULL"

since C's (void *)0 would also barf when being assigned to int.
So it's not a genuine __null feature ;-)


Jan
-- 
