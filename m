Return-Path: <linux-kernel-owner+w=401wt.eu-S1756698AbYGJT7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698AbYGJT7f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 15:59:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753287AbYGJT7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 15:59:24 -0400
Received: from nebensachen.de ([195.34.83.29]:43963 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753163AbYGJT7W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 15:59:22 -0400
X-Hashcash: 1:20:080710:rostedt@goodmis.org::YJsKlHCt5qrztgxN:0000000000000000000000000000000000000000001X8I
X-Hashcash: 1:20:080710:linux-kernel@vger.kernel.org::ae8QRUaD+AyK1tr5:0000000000000000000000000000000000319
X-Hashcash: 1:20:080710:mingo@elte.hu::Qpq8Yvtyg4KDV/YD:00004C9H
X-Hashcash: 1:20:080710:tglx@linutronix.de::l/WH7zUhwXrYLDfh:00000000000000000000000000000000000000000007f4F
X-Hashcash: 1:20:080710:peterz@infradead.org::lhjU8SC5KqhNbFsW:000000000000000000000000000000000000000001Cqr
X-Hashcash: 1:20:080710:clark.williams@gmail.com::WQRPO7Xy3v8ETzk/:0000000000000000000000000000000000000AVf9
X-Hashcash: 1:20:080710:torvalds@linux-foundation.org::D3sAaF0gV7C6ub2a:00000000000000000000000000000000055a
X-Hashcash: 1:20:080710:akpm@linux-foundation.org::2JOl4YbsRVD0czc9:0000000000000000000000000000000000000GkJ
X-Hashcash: 1:20:080710:randy.dunlap@oracle.com::vO/krDHGPNFS8QD1:0000000000000000000000000000000000000019IO
X-Hashcash: 1:20:080710:jonathan@jonmasters.org::bHfeqZ3+HTeuxFho:000000000000000000000000000000000000000hze
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
Date: Thu, 10 Jul 2008 21:59:01 +0200
In-Reply-To: <Pine.LNX.4.58.0807101242070.3740@gandalf.stny.rr.com> (Steven
	Rostedt's message of "Thu, 10 Jul 2008 12:46:01 -0400 (EDT)")
Message-ID: <87zlop7bp6.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> wrote:
> This is the long awaited ftrace.txt. It explains in quite detail how to
> use ftrace and the various tracers.
>
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>

Exactly what I've just been looking for. Very nice.

As I read through this enlightening peace, I took the liberty to make
some comments where I thought I'd spotted some mistake. Note that I'm
not a native English speaker nor familiar with all the terminology.
Also, I didn't exactly scratch my head when I had a bad feeling about
something but couldn't come up with a better idea straight away.
Basically, I just skimmed through the lines because im interested in the
matter.

Anyway, here it goes:

[...]
> +  available_tracers : This holds the different types of tracers that
> +		has been compiled into the kernel. The tracers

                have

> +		listed here can be configured by echoing in their
> +		name into current_tracer.
[...]
> +  trace_entries : This sets or displays the number of trace
> +		entries each CPU buffer can hold. The tracer buffers
> +		are the same size for each CPU, so care must be
> +		taken when modifying the trace_entries. The number
> +		of actually entries will be the number given

                   actual

> +		times the number of possible CPUS. The buffers
> +		are saved as individual pages, and the actual entries
> +		will always be rounded up to entries per page.

Not sure I understand the last sentence, but may be it's just me not
being familiar with the terminology.

[...]
> +  set_ftrace_filter : When dynamic ftrace is configured in, the
> +		code is dynamically modified to disable calling
> +		of the function profiler (mcount). This lets
> +		tracing be configured in with practically no overhead
> +		in performance.  This also has a side effect of
> +		enabling or disabling specific functions to be
> +		traced.  Echoing in names of functions into this
> +		file will limit the trace to only those files.

                                                  these functions?

> +
> +  set_ftrace_notrace: This has the opposite effect that
> +		set_ftrace_filter has. Any function that is added
> +		here will not be traced. If a function exists
> +		in both set_ftrace_filter and set_ftrace_notrace

                                                                (comma)

> +		the function will _not_ bet traced.
> +
[...]
> +  ftrace - function tracer that uses mcount to trace all functions.
> +		It is possible to filter out which functions that are

                                                             are to be

> +		traced when dynamic ftrace is configured in.
> +
[...]
> +  time: This differs from the trace output where as the trace output
> +	contained a absolute timestamp. This timestamp is relative
> +	to the start of the first entry in the the trace.

                                           double `the'

Actually, the whole description of this item feels a bit awkward.

> +
> +  delay: This is just to help catch your eye a bit better. And
> +	needs to be fixed to be only relative to the same CPU.
> +	The marks is determined by the difference between this

                  are

> +	current trace and the next trace.
> +	 '!' - greater than preempt_mark_thresh (default 100)
> +	 '+' - greater than 1 microsecond
> +	 ' ' - less than or equal to 1 microsecond.
> +
[...]
> +To disable one of the options, echo in the option appended with "no".

                                                     prepended?

> +
> +  echo noprint-parent > /debug/tracing/iter_ctrl
> +
> +To enable an option, leave off the "no".
> +
> +  echo sym-offest > /debug/tracing/iter_ctrl

          sym-offset

> +
> +Here are the available options:
[...]
> +  sym-offset - Display not only the function name, but also the offset
> +		in the function. For example, instead of seeing just
> +		"ktime_get" you will see "ktime_get+0xb/0x20"

                           (comma)                           (full stop)

[...]
> +  hex - similar to raw, but the numbers will be in a hexadecimal format.

           (capital S)

> +
> +  bin - This will print out the formats in raw binary.
> +
> +  block - TBD (needs update)
> +
> +  stacktrace - This is one of the options that changes the trace itself.

                                                  change

> +		When a trace is recorded, so is the stack of functions.
> +		This allows for back traces of trace sites.
> +
> +  sched-tree - TBD (any users??)
> +
> +
> +sched_switch
> +------------
> +
> +This tracer simply records schedule switches. Here's an example
> +on how to implement it.

             use?

[...]
> +When ftrace_enabled is set the tracers will also record the functions

                             (comma)

> +that are within the trace. The descriptions of the tracers
> +will also show an example with ftrace enabled.
> +
> +
> +irqsoff
> +-------
> +
> +When interrupts are disabled, the CPU can not react to any other
> +external event (besides NMIs and SMIs). This prevents the timer
> +interrupt from triggering or the mouse interrupt from letting the
> +kernel know of a new mouse event. The result is a latency with the
> +reaction time.
> +
> +The irqsoff tracer tracks the time interrupts are disabled and when

                             when

> +they are re-enabled. When a new maximum latency is hit, it saves off
> +the trace so that it may be retrieved at a later time. Every time a
> +new maximum in reached, the old saved trace is discarded and the new
> +trace is saved.
[...]
> +Note the above had ftrace_enabled not set. If we set the ftrace_enabled

                                                                        (comma)

> +we get a much larger output:
> +
[...]
> +Here we traced a 50 microsecond latency. But we also see all the
> +functions that were called during that time. Note that enabling

                                                          by enabling?

> +function tracing we endure an added overhead. This overhead may

                   (comma)

> +extend the latency times. But never the less, this trace has provided
> +some very helpful debugging.

                     debugging information?

> +
> +
> +preemptoff
> +----------
> +
> +When preemption is disabled we may be able to receive interrupts but

                              (comma)

> +the task can not be preempted and a higher priority task must wait
> +for preemption to be enabled again before it can preempt a lower
> +priority task.
> +
> +The preemptoff tracer traces the places that disables preemption.

                                                disable

> +Like the irqsoff, it records the maximum latency that preemption
> +was disabled. The control of preemptoff is much like the irqsoff.
[...]
> +Notice that the __do_softirq when called doesn't have a preempt_count.
> +It may seem that we missed a preempt enabled. What really happened
> +is that the preempt count is held on the threads stack and we
> +switched to the softirq stack (4K stacks in effect). The code
> +does not copy the preempt count, but because interrupts are disabled

                                                                       (comma)

> +we don't need to worry about it. Having a tracer like this is good
> +to let people know what really happens inside the kernel.
[...]
> +To record this time, use the preemptirqsoff tracer.
> +
> +Again, using this trace is much like the irqsoff and preemptoff tracers.
> +
> + # echo preemptoff > /debug/tracing/current_tracer

           preemptirqsoff

> + # echo 0 > /debug/tracing/tracing_max_latency
> + # echo 1 > /debug/tracing/tracing_enabled
> + # ls -ltr
> + [...]
> + # echo 0 > /debug/tracing/tracing_enabled
> + # cat /debug/tracing/latency_trace
> +# tracer: preemptirqsoff
[...]
> +This is a very interesting trace. It started with the preemption of
> +the ls task. We see that the task had the "need_resched" bit set
> +with the 'N' in the trace.  Interrupts are disabled in the spin_lock
> +and the trace started. We see that a schedule took place to run
> +sshd.  When the interrupts were enabled we took an interrupt.

                                          (comma)

> +On return of the interrupt the softirq ran. We took another interrupt

             from the interrupt handler,

> +while running the softirq as we see with the capital 'H'.
> +
> +
> +wakeup
> +------
> +
> +In Real-Time environment it is very important to know the wakeup
> +time it takes for the highest priority task that wakes up to the
> +time it executes. This is also known as "schedule latency".
> +I stress the point that this is about RT tasks. It is also important
> +to know the scheduling latency of non-RT tasks, but the average
> +schedule latency is better for non-RT tasks. Tools like
> +LatencyTop is more appropriate for such measurements.

              are

> +
> +Real-Time environments is interested in the worst case latency.

                          are

> +That is the longest latency it takes for something to happen, and
> +not the average. We can have a very fast scheduler that may only
> +have a large latency once in a while, but that would not work well
> +with Real-Time tasks.  The wakeup tracer was designed to record
> +the worst case wakeups of RT tasks. Non-RT tasks are not recorded
> +because the tracer only records one worst case and tracing non-RT
> +tasks that are unpredictable will overwrite the worst case latency
> +of RT tasks.
> +
> +Since this tracer only deals with RT tasks, we will run this slightly
> +different than we did with the previous tracers. Instead of performing
> +an 'ls' we will run 'sleep 1' under 'chrt' which changes the

          (comma)

> +priority of the task.
[...]
> +Running this on an idle system we see that it only took 4 microseconds

                                 (comma)

> +to perform the task switch.  Note, since the trace marker in the
> +schedule is before the actual "switch" we stop the tracing when

                                         (comma)

> +the recorded task is about to schedule in. This may change if
> +we add a new marker at the end of the scheduler.
[...]
> +Where as the setting of the NEED_RESCHED bit happens on the
> +task's stack. But because we are in a hard interrupt, the test
> +is with the interrupts stack which has that to be false. We don't

                                          ^^^^
Superfluous that? Don't understand that sentence.

> +see the 'N' until we switch back to the task's stack.
[...]
> +When dynamic ftrace is initialized, it calls kstop_machine to make it
> +act like a uniprocessor so that it can freely modify code without
> +worrying about other processors executing that same code.  At
> +initialization, the mcount calls are change to call a "record_ip"

                                        changed

> +function.  After this, the first time a kernel function is called,
> +it has the calling address saved in a hash table.
[...]
> +Two files that contain to the enabling and disabling of recorded
> +functions are:

Can this be expressed somewhat differently?

> +
> +  set_ftrace_filter
> +
> +and
> +
> +  set_ftrace_notrace
> +
> +A list of available functions that you can add to this files is listed

                                                     these

> +in:
> +
> +   available_filter_functions
[...]
> +Perhaps this isn't enough. The filters also allow simple wild cards.
> +Only the following is currently available
> +
> +  <match>*  - will match functions that begins with <match>

                                           begin

> +  *<match>  - will match functions that end with <match>
> +  *<match>* - will match functions that have <match> in it
[...]
> +This is because the '>' and '>>' act just like they do in bash.
> +To rewrite the filters, use '>'
> +To append to the filters, use '>>'
> +
> +To clear out a filter so that all functions will be recorded again.

                                                                     :

> +
> + # echo > /debug/tracing/set_ftrace_filter
> + # cat /debug/tracing/set_ftrace_filter
> + #
[...]
> +ftraced
> +-------
> +
> +As mentioned above, when dynamic ftrace is configured in, a kernel
> +thread wakes up once a second and checks to see if there are mcount
> +calls that need to be converted into nops. If there is not, then

                                                       are

> +it simply goes back to sleep. But if there is, it will call

                                              are

> +kstop_machine to convert the calls to nops.
[...]
> +Any write to the ftraced_enabled file will cause the kstop_machine
> +to run if there are recorded calls to mcount. This means that a

Incomplete sentence. 

> +user can manually perform the updates when they want to by simply

                                              (s)he wants

> +echoing a '0' into the ftraced_enabled file.
[...]
> +Having too much or not enough data can be troublesome in diagnosing
> +some issue in the kernel. The file trace_entries is used to modify
> +the size of the internal trace buffers. The numbers listed
> +is the number of entries that can be recorded per CPU. To know

   are

> +the full size, multiply the number of possible CPUS with the
> +number of entries.
> +
> + # cat /debug/tracing/trace_entries
> +65620
> +
> +Note, to modify this you must have tracing fulling disabled. To do that,

                       (comma)                fully / completely

> +echo "none" into the current_tracer.
[...]
> +The number of pages that will be allocated is a percentage of available
> +memory. Allocating too much will produces an error.

                                    produce


Regards,

Elias
