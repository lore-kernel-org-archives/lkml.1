Return-Path: <linux-kernel-owner+w=401wt.eu-S1761342AbXFWRGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761342AbXFWRGA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 13:06:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760387AbXFWRFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 13:05:53 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58403 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760282AbXFWRFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 13:05:52 -0400
Date: Sat, 23 Jun 2007 09:53:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, mingo@elte.hu,
       tglx@linutronix.de, hch@infradead.org, johnstul@us.ibm.com,
       oleg@tv-sign.ru, paulmck@linux.vnet.ibm.com, dipankar@in.ibm.com,
       davem@davemloft.net, kuznet@ms2.inr.ac.ru
Subject: Re: [RFC PATCH 5/5 v2] Convert tasklets to work queues
Message-Id: <20070623095359.4667514e.akpm@linux-foundation.org>
In-Reply-To: <20070622182315.571740041@goodmis.org>
References: <20070622182051.859570787@goodmis.org>
	<20070622182315.571740041@goodmis.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 22 Jun 2007 14:20:56 -0400 Steven Rostedt <rostedt@goodmis.org> wrote:
> This patch replaces the tasklet implementation with a work
> queue implementation while keeping the tasklet API.
> The API is still the same, and the drivers don't know that a
> work queue is being used.

I still think this sucks: we end up with a fairly pointless-looking wrapper
API which we wouldn't have put in the kernel except for messy legacy
editing-is-too-hard reasons.  In an ideal world, it'd be better just to get
in and do the hard work.

Anyway.  Please fix the many correct warnings which checkpatch.pl
generates, reissue the patches with a decent overall changelog (this series
had no rationale for the changes at all) and we'll see what happens.

Thanks.
