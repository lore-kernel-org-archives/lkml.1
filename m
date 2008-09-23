Return-Path: <linux-kernel-owner+w=401wt.eu-S1754993AbYIWDdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993AbYIWDdX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 23:33:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754334AbYIWDdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 23:33:15 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42225 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338AbYIWDdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 23:33:15 -0400
To: "Martin Bligh" <mbligh@google.com>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Mathieu Desnoyers" <compudj@krystal.dyndns.org>,
       "Steven Rostedt" <rostedt@goodmis.org>, od@novell.com,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: Unified tracing buffer
From: Andi Kleen <andi@firstfloor.org>
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com>
Date: Tue, 23 Sep 2008 05:33:10 +0200
In-Reply-To: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com> (Martin Bligh's message of "Fri, 19 Sep 2008 14:33:42 -0700")
Message-ID: <878wtjr0y1.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Martin Bligh" <mbligh@google.com> writes:

> During kernel summit and Plumbers conference, Linus and others
> expressed a desire for a unified
> tracing buffer system for multiple tracing applications (eg ftrace,
> lttng, systemtap, blktrace, etc) to use.

This is what relayfs always was promised to be, but apparently
never quite became. But before adding a new one I would recommend
to remove relayfs first.

-Andi
