Return-Path: <linux-kernel-owner+w=401wt.eu-S1752867AbYLSQZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867AbYLSQZX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 11:25:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751251AbYLSQZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 11:25:09 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:48339 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbYLSQZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 11:25:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=xlGfh55m9fn5lX7T3f78zPLBkFtXMDsbU5Hq4npXmGkytjcSePK3n+p5WfWDNMC3IG
         3N4iPsfI5j2LH8ZMLgmXmmmr+GH62tKb+o0J7KZk2GaaC8+YP5Vwdmqmpl1PvTjtNOeL
         QdQh9do0ziut9V4HpxTBPnx/zpppi4cHPXHK4=
Message-ID: <c62985530812190825k4e4f5a7apa37e1ab4bc35753a@mail.gmail.com>
Date: Fri, 19 Dec 2008 17:25:05 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: [patch 1/7] ftrace: fix task state printout
Cc: LKML <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       "Peter Zijlstra" <peterz@infradead.org>,
       "Clark Williams" <clark.williams@gmail.com>,
       "Gregory Haskins" <ghaskins@novell.com>,
       Linux-rt <linux-rt-users@vger.kernel.org>
In-Reply-To: <20081219155555.919550408@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081219155504.735865178@linutronix.de>
	 <20081219155555.919550408@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

2008/12/19 Thomas Gleixner <tglx@linutronix.de>:
> Impact: tracer task state decoding is wrong, size check is buggy
>
> The tracing code has interesting varieties of printing out task state.
> Unfortunalely only one of the instances is correct as it copies the
> code from sched.c:sched_show_task(). The others are plain wrong as
> they treatthe bitfield as an integer offset into the character
> array. Also the size check of the character array is wrong as it
> includes the trailing \0.
>
> Use a common state decoder inline which does the Right Thing.
>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>


You've already sent it out. It has been applied on -tip :-)
