Return-Path: <linux-kernel-owner+w=401wt.eu-S1752534AbYHKIg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534AbYHKIg7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 04:36:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751288AbYHKIgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 04:36:50 -0400
Received: from metis.extern.pengutronix.de ([83.236.181.26]:56002 "EHLO
	metis.extern.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751189AbYHKIgt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 04:36:49 -0400
From: Juergen Beisert <jbe@pengutronix.de>
Organization: Pengutronix - Linux Solutions for Science and Industry
To: linux-rt-users@vger.kernel.org
Date: Mon, 11 Aug 2008 10:36:36 +0200
User-Agent: KMail/1.9.9
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Clark Williams <williams@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Carsten Emde <ce@ceag.ch>
References: <alpine.LFD.1.10.0807252141420.574@apollo.tec.linutronix.de> <alpine.LFD.1.10.0807291440240.14925@apollo.tec.linutronix.de> <alpine.LFD.1.10.0807300006180.14925@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.10.0807300006180.14925@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200808111036.37998.jbe@pengutronix.de>
X-SA-Exim-Connect-IP: 83.236.181.29
X-SA-Exim-Mail-From: jbe@pengutronix.de
Subject: Re: 2.6.26-rt1
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on metis.extern.pengutronix.de)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CONFIG_GROUP_SCHED is enabled this compile error is back.

[...]
  CC      mm/bootmem.o
In file included from kernel/sched.c:1618:
kernel/sched_rt.c: In function 'inc_rt_tasks':
kernel/sched_rt.c:408: error: 'struct rq' has no member named 'online'

jbe
-- 
Dipl.-Ing. Juergen Beisert | http://www.pengutronix.de
 Pengutronix - Linux Solutions for Science and Industry
    Handelsregister: Amtsgericht Hildesheim, HRA 2686
         Vertretung Sued/Muenchen, Germany
   Phone: +49-8766-939 228 |  Fax: +49-5121-206917-9
