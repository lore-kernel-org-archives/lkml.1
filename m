Return-Path: <linux-kernel-owner+w=401wt.eu-S1754435AbYAOIHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435AbYAOIHc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 03:07:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752226AbYAOIHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 03:07:23 -0500
Received: from mail.gmx.net ([213.165.64.20]:54064 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750744AbYAOIHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 03:07:22 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19IZY8YQkpIeaa3Gzi9RB8bD9C+bjAZ7864/WN1pV
	maO6l8EcT2/CW3
Subject: Re: 2.6.24-rc7-rt1
From: Mike Galbraith <efault@gmx.de>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>
In-Reply-To: <1200317101.3733.14.camel@homer.simson.net>
References: <1200250801.9190.7.camel@localhost.localdomain>
	 <200801132143.34889.m.kozlowski@tuxland.pl>
	 <Pine.LNX.4.58.0801131552350.10093@gandalf.stny.rr.com>
	 <1200299260.4665.17.camel@homer.simson.net>
	 <478B0B7C.BA47.005A.0@novell.com>
	 <1200317101.3733.14.camel@homer.simson.net>
Content-Type: text/plain
Date: Tue, 15 Jan 2008 09:07:16 +0100
Message-Id: <1200384437.4113.16.camel@homer.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-01-14 at 14:25 +0100, Mike Galbraith wrote:

> I forgot about it too.  I'll likely poke at it again.

<poke>

push_rt_task()
  find_lock_lowest_rq()
    find_lowest_rq()
      return pick_optimal_cpu().

returned cpu is offline.  Box prefers -1.

	-Mike



