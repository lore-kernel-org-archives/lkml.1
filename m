Return-Path: <linux-kernel-owner+w=401wt.eu-S1752835AbZLMRxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835AbZLMRxR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 12:53:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751496AbZLMRxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 12:53:16 -0500
Received: from mail.perches.com ([173.55.12.10]:1151 "HELO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751485AbZLMRxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 12:53:15 -0500
Subject: Re: [tip:tracing/urgent] ftrace.h: Use common pr_info fmt string
From: Joe Perches <joe@perches.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
       linux-tip-commits@vger.kernel.org
In-Reply-To: <20091213145056.GA5268@nowhere>
References: <1260651974.2637.4.camel@Joe-Laptop.home>
	 <tip-4819568f23a8bef0ca99b740ca60fe2450ab0aac@git.kernel.org>
	 <1260715695.2146.412.camel@gandalf.stny.rr.com>
	 <20091213145056.GA5268@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 13 Dec 2009 09:53:14 -0800
Message-ID: <1260726794.8189.50.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-12-13 at 15:50 +0100, Frederic Weisbecker wrote:
> On Sun, Dec 13, 2009 at 09:48:15AM -0500, Steven Rostedt wrote:
> > >  		pr_info("event trace: Could not activate trace point "	\
> > > -			"probe to " #call "\n");			\
> > > +			"probe to %s\n", #call);			\
> > This reduces format string space a bit, but doesn't it just add another
> > string to the string tables #func == "func" as well as add code to pass
> > in another parameter?
> Yeah, I don't understand the purpose of this patch either...

For sched, it reduces size by ~1k.

