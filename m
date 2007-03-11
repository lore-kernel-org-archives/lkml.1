Return-Path: <linux-kernel-owner+w=401wt.eu-S964792AbXCKXS6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964792AbXCKXS6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 19:18:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964801AbXCKXS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 19:18:57 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:45352 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964792AbXCKXS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 19:18:56 -0400
Date: Mon, 12 Mar 2007 00:16:59 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Kyle Moffett <mrmacman_g4@mac.com>
cc: Daniel Hazelton <dhazelton@enter.net>,
       Cong WANG <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Style Question
In-Reply-To: <14DE5DBD-4164-4CDF-9690-631514EB15EF@mac.com>
Message-ID: <Pine.LNX.4.61.0703120015390.18623@yvahk01.tjqt.qr>
References: <2375c9f90703110715v4278f83flbc9fce6c542472a5@mail.gmail.com>
 <Pine.LNX.4.61.0703112134180.16857@yvahk01.tjqt.qr> <200703111641.52066.dhazelton@enter.net>
 <14DE5DBD-4164-4CDF-9690-631514EB15EF@mac.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 11 2007 18:01, Kyle Moffett wrote:
> On Mar 11, 2007, at 16:41:51, Daniel Hazelton wrote:
>> On Sunday 11 March 2007 16:35:50 Jan Engelhardt wrote:
>> > On Mar 11 2007 22:15, Cong WANG wrote:
>> > > So can I say using NULL is better than 0 in kernel?
>> > 
>> > On what basis? Do you even know what NULL is defined as in (C, not
>> > C++) userspace? Think about it.
>> 
>> IIRC, the glibc and GCC headers define NULL as (void*)0  :)
>
> On the other hand when __cplusplus is defined they define it to the
> "__null" builtin, which GCC uses to give type conversion errors for
> "int foo = NULL" but not "char *foo = NULL".  A "((void *)0)"
> definition gives C++ type errors for both due to the broken C++
> void pointer conversion problems.

I think that the primary reason they use __null is so that you can
actually do

	class foo *ptr = NULL;

because

	class foo *ptr = (void *)0;

would throw an error or at least a warning (implicit cast from void*
to class foo*).


Jan
-- 
