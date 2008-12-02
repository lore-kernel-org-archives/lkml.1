Return-Path: <linux-kernel-owner+w=401wt.eu-S1753935AbYLBVk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935AbYLBVk1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 16:40:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751930AbYLBVkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 16:40:12 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:10232 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982AbYLBVkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 16:40:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=S90l3kkUqzEIWTM6dXmRWziAGe2jgpIX2omn/UZTfbdhqx0ojYl9LaHoQbMETj0BHO
         jvMJ9+cWEV8GztbZYRg2b/mxUJK22ST7BFiIioxwVPxjPwrMjdqoYldfLCyJz4+moTWj
         A4DasrHFMhtywmiMLcL73ASrkryh3BqhCSZIw=
Message-ID: <c62985530812021340n47999897yfe1359792b96c8e3@mail.gmail.com>
Date: Tue, 2 Dec 2008 22:40:09 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH] tracing/function-branch-tracer: support for x86-64
Cc: "Ingo Molnar" <mingo@elte.hu>, "Tim Bird" <tim.bird@am.sony.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Alexander van Heukelum" <heukelum@mailshack.com>
In-Reply-To: <alpine.DEB.1.10.0812021619080.22547@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <49347147.8070405@gmail.com> <20081202090205.GA11632@elte.hu>
	 <alpine.DEB.1.10.0812021619080.22547@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/2 Steven Rostedt <rostedt@goodmis.org>:
> Hmm, I had issues with my mail server so I just received this. I was
> porting it to x86-64 last night too.

Oops...


> I'm also working on a way to trigger
> specific functions to trace instead of tracing all functions.

You mean only tracing one function and its tree of calls (by defining
a kind of root
of tracing?) as suggested Arjan?
Yeah, that would be great.

To define it through trace_filter, perhaps we could use the sign "^"
before a function name to say:
"all calls which starts with this function". I hope that wouldn't
confuse with the real sense that "^" has in regular
expressions.
