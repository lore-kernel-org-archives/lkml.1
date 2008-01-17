Return-Path: <linux-kernel-owner+w=401wt.eu-S1756777AbYAQSeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777AbYAQSeS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 13:34:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752668AbYAQSeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 13:34:05 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:50394 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbYAQSeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 13:34:04 -0500
Subject: Re: 2.6.24-rc8-rt1
From: Daniel Walker <dwalker@mvista.com>
To: Wolfgang Grandegger <wg@grandegger.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <478F9BCE.4030301@grandegger.com>
References: <1200544050.318.18.camel@localhost.localdomain>
	 <478F2A46.5070506@grandegger.com>
	 <1200586632.18731.141.camel@imap.mvista.com>
	 <478F9BCE.4030301@grandegger.com>
Content-Type: text/plain
Date: Thu, 17 Jan 2008 10:30:54 -0800
Message-Id: <1200594655.18731.148.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-01-17 at 19:17 +0100, Wolfgang Grandegger wrote:
> [    0.733248] TCP bind hash table entries: 2048 (order: 3, 57344
> bytes)
> [    0.741132] TCP: Hash tables configured (established 2048 bind
> 2048)
> [    0.747981] TCP reno registered
> [    0.805896] krcupreemptd setsched 0
> [    0.809657]   prio = 98

That's interesting .. You chould try running cyclictest at priority 99
to eliminate other threads that might get involved (using -p99 instead
of -p80 , I think) ..

Daniel

