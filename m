Return-Path: <linux-kernel-owner+w=401wt.eu-S1756633AbYGKHvc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756633AbYGKHvc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 03:51:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191AbYGKHvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 03:51:24 -0400
Received: from nebensachen.de ([195.34.83.29]:36162 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783AbYGKHvX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 03:51:23 -0400
X-Hashcash: 1:20:080711:rostedt@goodmis.org::iuxDB2C4y1l9sptG:0000000000000000000000000000000000000000003Jim
X-Hashcash: 1:20:080711:linux-kernel@vger.kernel.org::x1t5dzRw7U+WoO4i:0000000000000000000000000000000000wI3
X-Hashcash: 1:20:080711:mingo@elte.hu::q68uU0LjonTSeVyD:000008yW
X-Hashcash: 1:20:080711:tglx@linutronix.de::Dn4vLN5ZWM8eZhpy:00000000000000000000000000000000000000000004m4I
X-Hashcash: 1:20:080711:peterz@infradead.org::+1mhXSMYQRHBQus4:000000000000000000000000000000000000000000Vvg
X-Hashcash: 1:20:080711:clark.williams@gmail.com::+Ct6McTdFPuK42Jb:00000000000000000000000000000000000001UWG
X-Hashcash: 1:20:080711:torvalds@linux-foundation.org::sbJwjrjrvvjdC9wi:000000000000000000000000000000001U4C
X-Hashcash: 1:20:080711:akpm@linux-foundation.org::ROXFOAvzDaH63LBC:0000000000000000000000000000000000003GV2
X-Hashcash: 1:20:080711:randy.dunlap@oracle.com::XlC3PLOwPTUcVRXc:000000000000000000000000000000000000000ElD
X-Hashcash: 1:20:080711:jonathan@jonmasters.org::WitPexbSIFFsiUjC:0000000000000000000000000000000000000007Dx
From: Elias Oltmanns <eo@nebensachen.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Clark Williams <clark.williams@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Jon Masters <jonathan@jonmasters.org>
Subject: Re: [PATCH] ftrace: Documentation
References: <Pine.LNX.4.58.0807101242070.3740@gandalf.stny.rr.com>
	<87zlop7bp6.fsf@denkblock.local>
	<Pine.LNX.4.58.0807101909510.7719@gandalf.stny.rr.com>
Date: Fri, 11 Jul 2008 09:51:11 +0200
In-Reply-To: <Pine.LNX.4.58.0807101909510.7719@gandalf.stny.rr.com> (Steven
	Rostedt's message of "Thu, 10 Jul 2008 19:55:41 -0400 (EDT)")
Message-ID: <87zloo97v4.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> wrote:
> On Thu, 10 Jul 2008, Elias Oltmanns wrote:
>
>>
>> Steven Rostedt <rostedt@goodmis.org> wrote:
[...]
>> > +		times the number of possible CPUS. The buffers
>> > +		are saved as individual pages, and the actual entries
>> > +		will always be rounded up to entries per page.
>>
>> Not sure I understand the last sentence, but may be it's just me not
>> being familiar with the terminology.
>
> I should rewrite it then. I allocate the buffer by pages (a block of
> memory that is used in kernel allocation. Usually 4K). Since the entries
> are less than a page, if there is extra padding on the last page after
> all the requested entries have been allocated, I use the rest of the page
> to add entries that can still fit.

I see, thanks.

[...]
>> > +  ftrace - function tracer that uses mcount to trace all functions.
>> > +		It is possible to filter out which functions that are
>>
>>                                                              are to be
>
> Both ways sound OK to me. But then again, I would trust a non-native
> speaker more. Since they were actually taught the language ;-)

Most likely, both ways *are* OK; I was mainly concerned about the `that'
which irritates me.

>
>>
>> > +		traced when dynamic ftrace is configured in.
[...]
>> > +  stacktrace - This is one of the options that changes the trace itself.
>>
>>                                                   change
>
> Hmm, now this would be a good English question. "change" is for plural and
> "changes" is for singular. Now is "This is one of options" plural or
> singular.  I'm thinking singular, because it is "one of", but I'm not an
> English major.

Well, I couldn't name any particular rule to make my point but I'll
dissect that sentence in order to explain my thinking:

1. This is one of the options.

Well, we knew that anyway, so surely, something is missing.

2. This is an option that changes the trace itself.

Quite conclusive.

3. This is one of the options that change the trace itself.

The `that' clause refers to options, thus implying that there are more
then just this one that change the trace itself. I'm not sure whether
the fact that there is no comma before the `that' implies that the rest
of the sentence refers to the subject, though.

4. This is one of the options that changes the trace itself.

Personally, I think of this as the sum of 1. (no valuable information)
and 2. (a perfectly valid and meaningful statement), i.e., why not stick
to 2. In constrast, the third variant really does provide additional
information because the relative clause refers to options (plural).

Well, I really am clutching at straws here, I suppose. Actually, I dare
not argue with with you *and* Randy about this.

[...]
>> > +The irqsoff tracer tracks the time interrupts are disabled and when
>>
>>                              when
>
> Hmm, I don't like either "when"s. How about:
>
>   The irqsoff tracer tracks the time interrupts are disabled to the time
>   they are re-enabled.
>
> ??

Fine with me.

>
>>
>> > +they are re-enabled. When a new maximum latency is hit, it saves off
>> > +the trace so that it may be retrieved at a later time. Every time a
>> > +new maximum in reached, the old saved trace is discarded and the new
>> > +trace is saved.
>> [...]
>> > +Note the above had ftrace_enabled not set. If we set the ftrace_enabled
>>
>>                                                                         (comma)
>
> I have a lot of these. I just commented on someones writing in saying that
> you can use a "then" or a "comma" but don't leave both out. Seems I've
> been doing that a lot here.

I doubt you really can omit the comma either way since the conditional
precedes the main clause.

[...]
>> > +Where as the setting of the NEED_RESCHED bit happens on the
>> > +task's stack. But because we are in a hard interrupt, the test
>> > +is with the interrupts stack which has that to be false. We don't
>>
>>                                           ^^^^
>> Superfluous that? Don't understand that sentence.
>
> No really, I did proof read it...
>
> God that was an awful explanation.  OK, how about something like this:
>
>   Some task data is stored at the top of the tasks stack (need_resched and
>   preempt_count). The setting of the NEED_RESCHED sets the bit on the
>   task's real stack. The test for NEED_RESCHED looks at the current stack.
>   Since the current stack is the hard interrupt stack (as the kernel is
>   configured to use a separate stack for interrupts), the trace shows that
>   the need_resched bit has not yet been set.

Righht, thanks.

[...]
>> > +Two files that contain to the enabling and disabling of recorded
>> > +functions are:
>>
>> Can this be expressed somewhat differently?
>
> Did I write that??
> How about:
>
>   Two files are used, one for enabling and one for disabling the tracing
>   of recorded functions.
>
> I'm sure you'll tell me I missed a comma in there somewhere ;-)

Sorry to disappoint you, I could think of one. ;-)

[...]
>> > +ftraced
>> > +-------
>> > +
>> > +As mentioned above, when dynamic ftrace is configured in, a kernel
>> > +thread wakes up once a second and checks to see if there are mcount
>> > +calls that need to be converted into nops. If there is not, then
>>
>>                                                        are
>
> That sounds off. I see your point, but I'm not sure this applies for
> plural.  I can be wrong though.

Well, I could be persuaded to believe that this is idiomatic.

>
>>
>> > +it simply goes back to sleep. But if there is, it will call
>>
>>                                               are
>
> Same here.

Of course.

>
>>
>> > +kstop_machine to convert the calls to nops.
>> [...]
>> > +Any write to the ftraced_enabled file will cause the kstop_machine
>> > +to run if there are recorded calls to mcount. This means that a
>>
>> Incomplete sentence.
>
> hmm, how so?  Although I am missing a comma. I could also write it like
> "If there are recorded calls to mcount, any write to the ftraced_enabled
> file will cause kstop_machine to run".

Oh dear, I didn't exactly excel myself there, did I. Your original
sentence was quite alright and there was no comma missing either because
the conditional follows the main clause. Personally, though, I find the
new version easier to understand.

>
>>
>> > +user can manually perform the updates when they want to by simply
>>
>>                                               (s)he wants
>
> This is where I hate the English language, and will not be including this
> update. Sorry, I hate the whole she/he thing.  I simply rebel and use
> "they"!

Yes, I appreciate that. Actually, I was wondering at the time whether I
should suggest saying `users' insdead of `a user'.

>
>>
>> > +echoing a '0' into the ftraced_enabled file.

Regards,

Elias
