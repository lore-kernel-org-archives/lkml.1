Return-Path: <linux-kernel-owner+w=401wt.eu-S1755532AbYGLMtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532AbYGLMtV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 08:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752369AbYGLMtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 08:49:08 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:23770 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859AbYGLMtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 08:49:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=LQ28NLU4XLMCk/sZHpFLVqN+54t5gX9kWWj9h8PaDZUt/AMcgwFeNl1/GybpMcPdk7
         kt+guSnkLva2TrNDMbI3ni9o9koJO3AmHhOjuCvCh+HteG5H7IBluD+AcgW9BwSyUGU9
         eWFto/Qs4lcdP5dJdIdWuik/4AkzdJbRDDMGM=
Message-ID: <863e9df20807120549r793c93c3o4c6049bed8670149@mail.gmail.com>
Date: Sat, 12 Jul 2008 18:19:03 +0530
From: "Abhishek Sagar" <sagar.abhishek@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH] ftrace: Documentation
Cc: LKML <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Peter Zijlstra" <peterz@infradead.org>,
       "Clark Williams" <clark.williams@gmail.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Jon Masters" <jonathan@jonmasters.org>
In-Reply-To: <Pine.LNX.4.58.0807101242070.3740@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.58.0807101242070.3740@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2008 at 10:16 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> This is the long awaited ftrace.txt. It explains in quite detail how to
> use ftrace and the various tracers.

This is quite good. Thanks!

> +Output format:
> +--------------
> +
> +Here's an example of the output format of the file "trace"
> +
> +                             --------
> +# tracer: ftrace
> +#
> +#           TASK-PID   CPU#    TIMESTAMP  FUNCTION
> +#              | |      |          |         |
> +            bash-4251  [01] 10152.583854: path_put <-path_walk
> +            bash-4251  [01] 10152.583855: dput <-path_put
> +            bash-4251  [01] 10152.583855: _atomic_dec_and_lock <-dput
> +                             --------

A small caveat here...the function names may be substituted with a
"[unkown/kretprobe'd]" under special circumstances
(http://lkml.org/lkml/2008/5/27/275). May be that should be mentioned
here?

--
Regards,
Abhishek
