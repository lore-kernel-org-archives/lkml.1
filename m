Return-Path: <linux-kernel-owner+w=401wt.eu-S1752327AbXBYJsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327AbXBYJsK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 04:48:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752329AbXBYJsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 04:48:09 -0500
Received: from www.osadl.org ([213.239.205.134]:59224 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752327AbXBYJsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 04:48:08 -0500
Subject: Re: 2.6.20-git15 BUG: soft lockup detected on CPU#0! - timers?
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Michal Piotrowski <michal.k.k.piotrowski@googlemail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <6bffcb0e0702241445v562be44y5ddac6d6abdb5131@mail.gmail.com>
References: <6bffcb0e0702201054rb839bb2m11ef8d33bacffdb8@mail.gmail.com>
	 <1172008584.25076.0.camel@localhost.localdomain>
	 <6bffcb0e0702201437o66db38d5j3066eb3c9951a270@mail.gmail.com>
	 <1172072023.25076.64.camel@localhost.localdomain>
	 <6bffcb0e0702210738p687ca1bdt2c568d7ed5904fff@mail.gmail.com>
	 <1172088044.25076.125.camel@localhost.localdomain>
	 <45DCF644.9040009@googlemail.com> <45DD756D.3040006@googlemail.com>
	 <20070223060802.GA8562@elte.hu>
	 <6bffcb0e0702241445v562be44y5ddac6d6abdb5131@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 25 Feb 2007 10:53:28 +0100
Message-Id: <1172397209.25076.365.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michal,

On Sat, 2007-02-24 at 23:45 +0100, Michal Piotrowski wrote:
> Here is a dmesg after over 25 hours of uptime
> http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc1/git-dmesg3
> nothing new.

can you please turn off CONFIG_SCHED_SMT ? It seems all reports have one
thing in common:

CPU == P4 and CONFIG_SCHED_SMT turned on.

	tglx


