Return-Path: <linux-kernel-owner+w=401wt.eu-S1753932AbYI3ReY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932AbYI3ReY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 13:34:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752359AbYI3ReL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 13:34:11 -0400
Received: from mail7.sea5.speakeasy.net ([69.17.117.9]:35825 "EHLO
	mail7.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbYI3ReK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 13:34:10 -0400
Date: Tue, 30 Sep 2008 13:34:05 -0400
Message-Id: <200809301734.m8UHY5lg027393@dsl092-065-009.bos1.dsl.speakeasy.net>
From: Robert Krawitz <rlk@alum.mit.edu>
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org
In-reply-to: <48E25D6D.30504@kernel.org> (tj@kernel.org)
Subject: Re: Another one for fixup-storage
References: <4897809E.8070902@alum.mit.edu> <48E25D6D.30504@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

   Date: Wed, 01 Oct 2008 02:10:05 +0900
   From: Tejun Heo <tj@kernel.org>

   Robert Krawitz wrote:
   > This is for a Dell Inspiron E1705/9400.  I'm using a non-OEM disk (a
   > Hitachi 320 GB drive).

   Just one more question.  What do you mean by non-OEM?  It didn't come
   with the listed harddrive?

Correct.  I purchased and installed the hard drive after I bought the
laptop.

Anyway, here's my smartctl output.  My laptop was mostly fairly idle
during these 2 10-minute periods, although I was doing a few things
(an OOo document, for example).  It's a bit more than twice a minute:

# while true ; do smartctl -a /dev/sda |grep 193; sleep 600; done
193 Load_Cycle_Count        0x0012   093   093   000    Old_age   Always       -       72102
193 Load_Cycle_Count        0x0012   093   093   000    Old_age   Always       -       72124
193 Load_Cycle_Count        0x0012   093   093   000    Old_age   Always       -       72148
