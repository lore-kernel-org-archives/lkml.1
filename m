Return-Path: <linux-kernel-owner+w=401wt.eu-S1755416AbYITA0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416AbYITA0R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 20:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752642AbYITA0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 20:26:05 -0400
Received: from senator.holtmann.net ([87.106.208.187]:55383 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537AbYITA0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 20:26:05 -0400
Subject: Re: Unified tracing buffer
From: Marcel Holtmann <holtmann@linux.intel.com>
To: Martin Bligh <mbligh@google.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Steven Rostedt <rostedt@goodmis.org>, od@novell.com,
       "Frank Ch. Eigler" <fche@redhat.com>
In-Reply-To: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com>
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 20 Sep 2008 02:26:52 +0200
Message-Id: <1221870412.6782.69.camel@californication>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Martin,

> During kernel summit and Plumbers conference, Linus and others
> expressed a desire for a unified
> tracing buffer system for multiple tracing applications (eg ftrace,
> lttng, systemtap, blktrace, etc) to use.
> This provides several advantages, including the ability to interleave
> data from multiple sources,
> not having to learn 200 different tools, duplicated code/effort, etc.

I talked with Thomas and Steven about it during lunch and we might wanna
also use it for sniffing/monitoring/capturing efforts. Inaky and I
talked about unifying things like usbmon, hcidump, tcpdump etc. with a
common interface into the kernel. Currently every subsystem does it
differently. Especially when it comes to add monitor support to SDIO we
ran into the problem that we don't just wanna invent another interface.

Right now I haven't spent much time on this and regret that I didn't sit
together with you guys yesterday, but it was not that high priority on
my list of nice things to have. Anyway, since I am mostly interested in
subsystems that copy a lot of packets around, it would be nice to only
reference to the data. For example for structures like SKBs and URBs and
only have to copy the data if we have a consumer. My thoughts :)

Regards

Marcel


