Return-Path: <linux-kernel-owner+w=401wt.eu-S1756019AbZCJPss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019AbZCJPss (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 11:48:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753465AbZCJPsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 11:48:38 -0400
Received: from mail-bw0-f178.google.com ([209.85.218.178]:65000 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821AbZCJPsh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 11:48:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=B0DyNUNQA4nn6kyWHT6D6tAF4Ys2/LIY+BZ5TZM6CuCQ9YStzq39J63WkP2enS245j
         bLWdi7Vq5uAWqdd1vmZN83zOmqodB4/asMZHn1ILcfzZvB7ws9y2Ev6dUK4xgw11CzIO
         Z7fwXM+T6+FbISFzK1j38ENbRNj5SWbRPa0us=
MIME-Version: 1.0
In-Reply-To: <1236684077.25234.138.camel@laptop>
References: <20090310045710.286915983@goodmis.org>
	 <20090310045811.084130677@goodmis.org> <20090310105624.GD6825@nowhere>
	 <1236684077.25234.138.camel@laptop>
Date: Tue, 10 Mar 2009 16:48:34 +0100
Message-ID: <c62985530903100848x45d65e02u61dbf6b972f9b840@mail.gmail.com>
Subject: Re: [PATCH 3/7] tracing: use generic __stringify
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Theodore Tso <tytso@mit.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       "Martin J. Bligh" <mbligh@mbligh.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Larry Woodman <lwoodman@redhat.com>, Jason Baron <jbaron@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Jiaying Zhang <jiayingz@google.com>,
       Steven Rostedt <srostedt@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/3/10 Peter Zijlstra <peterz@infradead.org>:
> On Tue, 2009-03-10 at 11:56 +0100, Frederic Weisbecker wrote:
>> On Tue, Mar 10, 2009 at 12:57:13AM -0400, Steven Rostedt wrote:
>
>> > This removes the custom made STR(x) macros in the tracer and uses
>> > the generic __stringify macro instead.
>
>> Why not simply use the # ?
>
>> > -#define __STR(x) #x
>> > -#define STR(x) __STR(x)
>
> #include <stdio.h>
>
> #define FOO bar
>
> #define __STR(x) #x
> #define STR(x) __STR(x)
>
> void main(void)
> {
>        printf("%s %s\n", __STR(FOO), STR(FOO));
> }
>
> $ gcc -o str str.c; ./str
> str.c: In function ‘main’:
> str.c:9: warning: return type of ‘main’ is not ‘int’
> FOO bar


Thank you both for the explanation.
