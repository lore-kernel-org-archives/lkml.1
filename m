Return-Path: <linux-kernel-owner+w=401wt.eu-S1751905AbXDATHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751905AbXDATHp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 15:07:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751833AbXDATHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 15:07:44 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:59707 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751905AbXDATHo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 15:07:44 -0400
Date: Sun, 1 Apr 2007 21:06:50 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Ken Chen <kenchen@google.com>
cc: Tomas M <tomas@slax.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] remove artificial software max_loop limit
In-Reply-To: <b040c32a0704011110n639d6ea4h447646b6da92974e@mail.gmail.com>
Message-ID: <Pine.LNX.4.61.0704012106010.16977@yvahk01.tjqt.qr>
References: <b040c32a0703300053u110063b0u80ee0e7b9dd158c2@mail.gmail.com> 
 <b040c32a0703300148w479cf4cdw667cf464edf7c725@mail.gmail.com> 
 <Pine.LNX.4.61.0703301105190.31834@yvahk01.tjqt.qr> 
 <b040c32a0703300225r3f8b1daah2f95e8af26c0d867@mail.gmail.com> 
 <20070330141524.5f6cff29.akpm@linux-foundation.org>  <460FE380.2050608@slax.org>
 <460FE478.9070901@slax.org> <b040c32a0704011110n639d6ea4h447646b6da92974e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 1 2007 11:10, Ken Chen wrote:
> On 4/1/07, Tomas M <tomas@slax.org> wrote:
>
>> I believe that IF you _really_ need to preserve the max_loop module 
>> parameter, then the parameter should _not_ be ignored, rather it 
>> should have the same function like before - to limit the loop driver 
>> so if you use max_loop=10 for example, it should not allow loop.c to 
>> create more than 10 loops.
>
> Blame on the dual meaning of max_loop that it uses currently: to 
> initialize a set of loop devices and as a side effect, it also sets 
> the upper limit.  People are complaining about the former constrain, 
> isn't it?  Does anyone uses the 2nd meaning of upper limit?

Who cares if the user specifies max_loop=8 but still is able to open up 
/dev/loop8, loop9, etc.? max_loop=X basically meant (at least to me) 
"have at least X" loops ready.


Jan
-- 
