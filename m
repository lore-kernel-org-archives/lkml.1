Return-Path: <linux-kernel-owner+w=401wt.eu-S1755011AbZLIGPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755011AbZLIGPm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 01:15:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751130AbZLIGPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 01:15:39 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57367 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754531AbZLIGPf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 01:15:35 -0500
Date: Wed, 9 Dec 2009 07:15:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Carsten Emde <Carsten.Emde@osadl.org>,
       Olof Johansson <olof@lixom.net>, hpa@zytor.com, tglx@linutronix.de
Subject: Re: [PATCH][GIT PULL][v2.6.33] tracing: Remove comparing of NULL to
 va_list in trace_array_vprintk()
Message-ID: <20091209061528.GA26687@elte.hu>
References: <4B01AE5D.1010801@osadl.org>
 <tip-c13d2f7c3231e873f30db92b96c8caa48f100f33@git.kernel.org>
 <20091206051352.GA4628@lixom.net>
 <4B1BAB74.104@osadl.org>
 <1260332397.2146.38.camel@gandalf.stny.rr.com>
 <20091209055602.GB2512@elte.hu>
 <20091209061148.GA14010@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091209061148.GA14010@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

>  efcf61a: tracing: Remove comparing of NULL to va_list in trace_array_vprintk()

the real culprit was:

  6e0573f: tracing: Buffer the output of seq_file in case of filled buffer

so i kept this commit:

  c521efd: tracing: Add pipe_close interface

and skipped the rest for now - please resend if this is fixed.

	Ingo
