Return-Path: <linux-kernel-owner+w=401wt.eu-S1756867AbYKLXlM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756867AbYKLXlM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 18:41:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755812AbYKLXft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 18:35:49 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:44271 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756064AbYKLXfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 18:35:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=I3ELa871ZmhO8Tnkf2VhihBD14GOa6nCqaN9gv0xfvuA+tF+ZAHDEmmwulMERERf1M
         cDtU0sPRxGS7yIKNl6eUWvNCX/pT7mm4snIhuoFsf7BwrIt/9eFB2SKuMB5lh0x+3u6M
         VccdL5kBtHGpKxDaM/u88D+OLaFu7nHhQf/d8=
Message-ID: <c62985530811121535t13a60c93y9e4c22e365ca1b34@mail.gmail.com>
Date: Thu, 13 Nov 2008 00:35:44 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH 2/2] tracing/function-return-tracer: Call prepare_ftrace_return by registers
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0811121824380.21116@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <491B4F63.3090909@gmail.com> <20081112221623.GB6125@elte.hu>
	 <c62985530811121422w6d33de3cp506bdf1aa96efd81@mail.gmail.com>
	 <alpine.DEB.1.10.0811121824380.21116@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/13 Steven Rostedt <rostedt@goodmis.org>:
>
> On Wed, 12 Nov 2008, Fr?d?ric Weisbecker wrote:
>
>> 2008/11/12 Ingo Molnar <mingo@elte.hu>:
>> >
>> > btw., should we now rename it all to the function-cost tracer?
>>
>> Yes. I'm preparing a patch to do these renames....
>
> I still need to look deeper at your patch set, but what about
> "ftrace-exit"?  Perhaps in the future this could be used by other tracers
> to record exiting of a function.


Hmm... The whole thing is splitted in two levels: the infrastructure
to trace on call and return (and call
a return handler) and the higher level tracer.
The first could be called ftrace_exit because it is waht it does.
And the second is much more about cost evaluation of functions and so
could be named function_cost. Its
functions and structures could have this in their name whereas the low
level things could have ftrace_exit in
their name.

What do you think?
