Return-Path: <linux-kernel-owner+w=401wt.eu-S1752551AbYKKTPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551AbYKKTPA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 14:15:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751374AbYKKTOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 14:14:52 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:14920 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207AbYKKTOv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 14:14:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=X5avCEUqOv9INvNIVI49sdLbhKdz8iqoxMdCz99/JXyc0+lgQ9pswljQj0ZAha9QuG
         aa6psDFDmCQuGv7aWOBbX83rYS+nf1rG2toHnrPAsssaFYTJXgp2/FYMkcOtI2rdIPad
         xdOp0kNGsGcj16ZUzva94F7VMQ4dyokoHaVXw=
Message-ID: <c62985530811111114t21a4e446i5e6ea68ce964dba9@mail.gmail.com>
Date: Tue, 11 Nov 2008 20:14:50 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [RFC v3][PATCH 0/2] Make ftrace able to trace function return
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20081111184311.GA21151@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <49191C31.1050402@gmail.com> <20081111094312.GA16496@elte.hu>
	 <c62985530811110730x13bc92abo891b49934ea2ae6f@mail.gmail.com>
	 <20081111171455.GA8201@elte.hu>
	 <c62985530811110924p28d3ff7i3ce8ff0d86ca2fb8@mail.gmail.com>
	 <20081111184311.GA21151@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/11 Ingo Molnar <mingo@elte.hu>:
>
> * Frédéric Weisbecker <fweisbec@gmail.com> wrote:
>
>> > at the risk of bikeshed-painting this issue too much, the problem
>> > with function_return is that it has little meaning to actual users
>> > and even to developers. What does the "return" mean? We know what
>> > it means, because we know that opposed to function entry we'll
>> > also capture function returns, and hence be able to do full
>> > function call tracing.
>> >
>> > so function_full i thought to conduct this aspect of it better.
>> > But suggestions are welcome.
>>
>>
>> Ok. Let's change into function_full, after all, I think that this
>> tool will be mostly used with a parsing pass of its traces with a
>> script to produce statistics and hierarchical representation like
>> does draw_functrace.py After that, the order of apparition of the
>> functions in the trace will not really matter.
>
> how about function_cost ?
>
> that's what it's primarily about at this stage: the ability to capture
> entry+exit, and have the cost printed.
>
> as opposed to function tracer, which traces function entry events, but
> does not try to build a coherent picture about per function execution
> cost.
>
>        Ingo
>

Ah yes. That's better!
