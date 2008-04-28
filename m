Return-Path: <linux-kernel-owner+w=401wt.eu-S935076AbYD1QZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935076AbYD1QZk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 12:25:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932545AbYD1QZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 12:25:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53836 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752731AbYD1QZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 12:25:28 -0400
Date: Mon, 28 Apr 2008 09:25:08 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Harvey Harrison <harvey.harrison@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>
Subject: Re: [PATCH] bitops: simplify generic bit finding functions
In-Reply-To: <alpine.LFD.1.10.0804281534530.3261@apollo.tec.linutronix.de>
Message-ID: <alpine.LFD.1.10.0804280924270.3119@woody.linux-foundation.org>
References: <1209327591.14173.74.camel@brick> <alpine.LFD.1.10.0804271325350.3119@woody.linux-foundation.org> <alpine.LFD.1.10.0804281534530.3261@apollo.tec.linutronix.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 28 Apr 2008, Thomas Gleixner wrote:
>
> How about making the optimization controlled by a config switch so
> arch maintainers can decide whether they want to enable the constant
> optimization or unconditionally call the lib function ?

No.

This is just making that damn header line look worse and worse.

Is there a _reason_ to optimize this stupid function this way?

		Linus
