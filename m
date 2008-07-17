Return-Path: <linux-kernel-owner+w=401wt.eu-S933407AbYGQVng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933407AbYGQVng (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 17:43:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756709AbYGQVn2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 17:43:28 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:13514 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754793AbYGQVn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 17:43:27 -0400
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "Alex Nixon (Intern)" <Alex.Nixon@eu.citrix.com>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ian Campbell <Ian.Campbell@eu.citrix.com>
Subject: Re: Large increase in context switch rate
From: Andi Kleen <andi@firstfloor.org>
References: <487E43D9.7080703@goop.org> <1216286250.5232.67.camel@twins>
	<487F5F15.4050208@goop.org>
	<0E902970173AF84089673FA54B7FE78A32906B@lonpexch01.citrite.net>
	<487F6913.2000602@goop.org>
	<0E902970173AF84089673FA54B7FE78A32906C@lonpexch01.citrite.net>
	<487F6F1F.2030808@goop.org>
Date: Thu, 17 Jul 2008 23:43:24 +0200
In-Reply-To: <487F6F1F.2030808@goop.org> (Jeremy Fitzhardinge's message of "Thu, 17 Jul 2008 09:11:11 -0700")
Message-ID: <87mykgrxtv.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 17 Jul 2008 21:43:23.0304 (UTC) FILETIME=[230E7280:01C8E856]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:
>
> OK, but that still doesn't account for the relatively large increase
> from 2.6.18 -> 2.6.26.  You're using HZ=100 in both cases, I presume.
>
> The other variable is NOHZ and highres timers.  You could try turning
> those off in 2.6.26.  Also, CONFIG_PREEMPT could well make a
> difference.  2.6.18-xen doesn't support CONFIG_PREEMPT at all, but
> pvops(-xen) does.

If it's that easily reproducible you could just bisect it?

-Andi
