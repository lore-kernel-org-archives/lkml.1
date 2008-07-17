Return-Path: <linux-kernel-owner+w=401wt.eu-S1760648AbYGQPVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760648AbYGQPVn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 11:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755479AbYGQPVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 11:21:35 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37527 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043AbYGQPVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 11:21:35 -0400
Subject: RE: Large increase in context switch rate
From: Peter Zijlstra <peterz@infradead.org>
To: "Alex Nixon (Intern)" <Alex.Nixon@eu.citrix.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ian Campbell <Ian.Campbell@eu.citrix.com>
In-Reply-To: <0E902970173AF84089673FA54B7FE78A32906B@lonpexch01.citrite.net>
References: <487E43D9.7080703@goop.org> <1216286250.5232.67.camel@twins>
	 <487F5F15.4050208@goop.org>
	 <0E902970173AF84089673FA54B7FE78A32906B@lonpexch01.citrite.net>
Content-Type: text/plain
Date: Thu, 17 Jul 2008 17:21:43 +0200
Message-Id: <1216308103.5232.96.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-17 at 16:14 +0100, Alex Nixon (Intern) wrote:
> Yeah I've checked - the number of context switches seems to be around
> 60k regardless of whether CONFIG_PARAVIRT is switched on, and regardless
> of whether it's running in domu or native (-j4 on dual core)

I'm seeing:

procs -----------memory---------- ---swap-- -----io---- --system-- -----cpu------
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st

 4  0      0 1148916 120340 472040    0    0     0  1912 2225 3662 78 22  0  0  0
 4  0      0 1130192 120556 489844    0    0     0  1974 2220 3461 77 22  0  0  0

doing make -j4

This is on x86_64 SMP PREEMPT HZ=1000 !PARAVIRT 
(Linus' tree as of somewhere earlier today)



