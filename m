Return-Path: <linux-kernel-owner+w=401wt.eu-S1753652AbYAWPvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652AbYAWPvQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 10:51:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751743AbYAWPvB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 10:51:01 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:10314 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbYAWPvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 10:51:00 -0500
Subject: Re: 2.6.24-rc8-rt1: Strange latencies on mpc5200 powerpc
From: Daniel Walker <dwalker@mvista.com>
To: Luotao Fu <l.fu@pengutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Wolfgang Grandegger <wg@grandegger.com>,
       LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20080123145340.GE6200@pengutronix.de>
References: <1200544050.318.18.camel@localhost.localdomain>
	 <478F2A46.5070506@grandegger.com>  <20080123145340.GE6200@pengutronix.de>
Content-Type: text/plain
Date: Wed, 23 Jan 2008 07:50:19 -0800
Message-Id: <1201103419.13596.3.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-01-23 at 15:53 +0100, Luotao Fu wrote:

> I was doing some tests on my mpc5200b Board to reproduce the high latency as
> measured by wolfgang.
> 
> I ran some tests with 
> while [ 1 ]; do ls /bin;done
> as non-rt workload, as in Wolfgangs Scenario.
> 

Can you try enabling CRITICAL_PREEMPT_TIMING only, and not latency
tracing .. You won't get a trace, but you will get some indication of
the start/stop points of the latency if it's preempt latency, and a
measurement of the longest latency..

Daniel

