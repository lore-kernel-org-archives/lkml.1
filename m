Return-Path: <linux-kernel-owner+w=401wt.eu-S1754255AbYGKT6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255AbYGKT6Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 15:58:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754543AbYGKT6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 15:58:17 -0400
Received: from old-tantale.fifi.org ([64.81.30.200]:33316 "EHLO
	old-tantale.fifi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309AbYGKT6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 15:58:17 -0400
To: john stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, macro@linux-mips.org
Subject: Re: 2.6.25.9: system clocks works normally then speeds up 4x...
References: <87d4lm2792.fsf@old-tantale.fifi.org>
	<1f1b08da0807091255s77033943t2b686ddb537ceaae@mail.gmail.com>
	<874p6y25es.fsf@old-tantale.fifi.org>
	<1215634125.6149.8.camel@localhost.localdomain>
	<87wsjuzsmr.fsf@old-tantale.fifi.org>
	<1215638499.6149.16.camel@localhost.localdomain>
	<87mykqzn85.fsf@old-tantale.fifi.org>
Mail-Copies-To: nobody
From: Philippe Troin <phil@fifi.org>
Date: 11 Jul 2008 12:53:49 -0700
In-Reply-To: <87mykqzn85.fsf@old-tantale.fifi.org>
Message-ID: <87bq14nqnm.fsf@old-tantale.fifi.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.2
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Philippe Troin <phil@fifi.org> writes:

> I've rebooted without noapic, and I will monitor and log these numbers
> and see how it goes.

So I've been monitoring local timer interrupts since the last reboot.
Last reboot was on July 9 at 3:14 PM.

I've been logging grep LOC /proc/interrupts every 10 seconds.

Initially, both CPUs log about 1000 LOC interrupts per second.
All of a sudden, CPU1 starts receving only 20 per second while CPU0
keeps getting its normal allotment of 1000 per second.

This is the time where it happens:

Thu Jul 10 12:13:59 PDT 2008: LOC:   75616236   75616322   Local timer interrupts
Thu Jul 10 12:14:09 PDT 2008: LOC:   75626255   75626341   Local timer interrupts
Thu Jul 10 12:14:19 PDT 2008: LOC:   75636275   75636360   Local timer interrupts
Thu Jul 10 12:14:29 PDT 2008: LOC:   75646293   75646379   Local timer interrupts
Thu Jul 10 12:14:39 PDT 2008: LOC:   75656312   75650462   Local timer interrupts
Thu Jul 10 12:14:49 PDT 2008: LOC:   75666355   75650857   Local timer interrupts
Thu Jul 10 12:14:59 PDT 2008: LOC:   75676378   75651251   Local timer interrupts
Thu Jul 10 12:15:09 PDT 2008: LOC:   75686403   75651645   Local timer interrupts
Thu Jul 10 12:15:19 PDT 2008: LOC:   75696420   75652039   Local timer interrupts
Thu Jul 10 12:15:29 PDT 2008: LOC:   75706439   75652433   Local timer interrupts
Thu Jul 10 12:15:39 PDT 2008: LOC:   75716476   75652827   Local timer interrupts
Thu Jul 10 12:15:49 PDT 2008: LOC:   75726495   75653221   Local timer interrupts
Thu Jul 10 12:15:59 PDT 2008: LOC:   75736514   75653615   Local timer interrupts
Thu Jul 10 12:16:09 PDT 2008: LOC:   75746548   75654009   Local timer interrupts
Thu Jul 10 12:16:19 PDT 2008: LOC:   75756573   75654403   Local timer interrupts

Phil.
