Return-Path: <linux-kernel-owner+w=401wt.eu-S1754285AbYI3OWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285AbYI3OWk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 10:22:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752475AbYI3OWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 10:22:32 -0400
Received: from mail8.sea5.speakeasy.net ([69.17.117.10]:34151 "EHLO
	mail8.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbYI3OWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 10:22:32 -0400
Date: Tue, 30 Sep 2008 10:22:29 -0400
Message-Id: <200809301422.m8UEMT2F026609@dsl092-065-009.bos1.dsl.speakeasy.net>
From: Robert Krawitz <rlk@alum.mit.edu>
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org
In-reply-to: <48E234B8.4050009@kernel.org> (tj@kernel.org)
Subject: Re: Another one for fixup-storage
References: <4897809E.8070902@alum.mit.edu> <48E0824B.4010408@kernel.org> <200809291141.m8TBfxiU004269@dsl092-065-009.bos1.dsl.speakeasy.net> <48E234B8.4050009@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

   Date: Tue, 30 Sep 2008 23:16:24 +0900
   From: Tejun Heo <tj@kernel.org>
   MIME-Version: 1.0
   CC: linux-kernel@vger.kernel.org
   Content-Type: text/plain; charset=UTF-8

   Robert Krawitz wrote:
   >    Date: Mon, 29 Sep 2008 16:22:51 +0900
   >    From: Tejun Heo <tj@kernel.org>
   > 
   >    Robert Krawitz wrote:
   >    > This is for a Dell Inspiron E1705/9400.  I'm using a non-OEM disk (a
   >    > Hitachi 320 GB drive).
   >    > 
   >    > Note that matching on "MP061" doesn't work -- it needs to be "MP061*"
   >    > due to the way dmidecode seems to return the data (with a bunch of
   >    > spaces after the tag).  Hence I've attached the data rather than merely
   >    > 
   >    > I've only had this thing a month or so and already had over 70,000
   >    > unload cycles.  Ick.
   > 
   >    Can you please attach the result of "smartctl -a" output?
   > 
   > # smartctl -a /dev/sda
   > smartctl 5.39 2008-05-08 21:56 [x86_64-unknown-linux-gnu] (local build)
   > Copyright (C) 2002-8 by Bruce Allen, http://smartmontools.sourceforge.net

   Thanks.  And how much does the load cycle count increase per hour
   without any adustment?

I didn't count it for a full hour (I put the workaround in place over
a month ago); it looked like it was incrementing something between 2
and 5 times per minute, as I recall.

-- 
Robert Krawitz                                     <rlk@alum.mit.edu>

Tall Clubs International  --  http://www.tall.org/ or 1-888-IM-TALL-2
Member of the League for Programming Freedom -- mail lpf@uunet.uu.net
Project lead for Gutenprint   --    http://gimp-print.sourceforge.net

"Linux doesn't dictate how I work, I dictate how Linux works."
--Eric Crampton
