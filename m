Return-Path: <linux-kernel-owner+w=401wt.eu-S1755818AbYFGTrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818AbYFGTrd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 15:47:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752422AbYFGTr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 15:47:26 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49778 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225AbYFGTr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 15:47:26 -0400
Message-ID: <484AE5C9.9070306@firstfloor.org>
Date: Sat, 07 Jun 2008 21:47:21 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kmemcheck: don't track pages allocated with interrupts
 disabled
References: <20080607143242.GA2893@damson.getinternet.no>	 <484AC165.7000702@firstfloor.org> <19f34abd0806071115s3e50d662p190a65fa2f091c7b@mail.gmail.com>
In-Reply-To: <19f34abd0806071115s3e50d662p190a65fa2f091c7b@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Maybe we can do the splitting when kmemcheck is enabled for the first
> time, either with the proc handler or at boot if kmemcheck=1 is passed
> on the command line. Both of these contexts should/can be
> !irqs_disabled(), I think.

You could always split at boot when the CONFIG is enabled. I assume the
CONFIG alone has already quite a lot of overhead and it will be only
on in debug kernels and adding some more TLB misses shouldn't be really
a problem. Using 2MB pages in kernel is merely  an optimization.

-Andi


