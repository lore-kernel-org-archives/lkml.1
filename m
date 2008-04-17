Return-Path: <linux-kernel-owner+w=401wt.eu-S935907AbYDQKHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935907AbYDQKHZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 06:07:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934757AbYDQJyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:54:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33518 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932667AbYDQJyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:54:50 -0400
Date: Thu, 17 Apr 2008 02:53:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [v2.6.26] what's brewing in x86.git for v2.6.26
Message-Id: <20080417025352.fd8e8d17.akpm@linux-foundation.org>
In-Reply-To: <20080417093025.GA17389@elte.hu>
References: <20080416202338.GA6007@elte.hu>
	<20080417002552.5742ad65.akpm@linux-foundation.org>
	<20080417083000.GA4935@elte.hu>
	<20080417014054.ea788f1f.akpm@linux-foundation.org>
	<20080417090626.GA14383@elte.hu>
	<20080417021813.04df7912.akpm@linux-foundation.org>
	<20080417093025.GA17389@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


btw: ftrace.  I didn't pay much attention to the early patches when they
flew past a couple of months ago and there's been basically no email about
it since (unless it's on some other list?)

Changelogs don't seem to explain it much and it seems to be undocumented. 
It's nicely commented, but it would be useful to at least present the
kernel<->userspace API in a way which can be reviewed.


You'd think that uninlining ftrace_ip_in_hash() would save a few bytes, but
it saves zero.  Even noinline doesn't change it.  Weird.

<checks>

hm, gcc has gone and ignored the `inline'.  heh.
