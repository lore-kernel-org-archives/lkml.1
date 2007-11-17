Return-Path: <linux-kernel-owner+w=401wt.eu-S1760809AbXKQRTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760809AbXKQRTg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 12:19:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755407AbXKQRT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 12:19:28 -0500
Received: from py-out-1112.google.com ([64.233.166.177]:28459 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754762AbXKQRT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 12:19:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=ptVCmvuVNjoMvpYpIKNij8N9I5XQDbyyPbcpZZQilRWqFFdJ6FW1H7Y1vsy8qMir4XjaErA9WYDz4zusLsoMhhc6e4U5GJy0mb5M4EhzsD8I2bPDxIKs1fuva8dSCpXEjoaPk6FCtYyXKQXSWYwPKt+nPNJq2SFMLlsBz9NWs5M=
Message-ID: <1d7226b10711170919x10689374k807c027b93236fb@mail.gmail.com>
Date: Sat, 17 Nov 2007 18:19:25 +0100
From: "Patrick DEMICHEL" <dmlpat@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: perfmon2 merge news
Cc: dmlpat@gmail.com
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yet another noisy linux HPC user

I hope to convince you, lkml developers, to pay more attention to our
HPC performance problems.

I will not try to convince you that our problems are also the problems
of many others users, I hope they will do it directly.

Imagine my company bought an expensive complex multi nodes, multi
sockets, multi cores machine.


This is cheap today, around 10M$
My company made the strange decision to go for linux, in fact we had
no choice : OOPS
This machine will be used to solve many fundamental problems like
meteorology, life&sciences, nanotechnologies, technologies, maths,
climatology, ...
Many of our scientists and developers will try to exploit the
potential of this machine to make some radically new sciences and make
breakthroughs in their domains. Some of those results could have a
major impact on everybody's life.

Then you see this is not just the problem of a bunch of desperate HPC users.

Moore's Law gave us the opportunity to solve many fundamental problems
by offering tons of cheap transistors,

but we all have 1 major problem : how to optimize our codes in that
context of massive parallelism?

Any idea what is massive?

Maybe you start to be familiar with tuning 4 cores.

We target shortly tuning millions of heterogeneous cores.

Good news for you, this is not the only problem we need to solve, but
this one is very serious.
And we know this is just an intermediate step towards somethings
continuously more complex and challenging.
There are tons of papers in the WEB written by many talented and
motivated people.
You need to be motivated to stay in this business :-)

Developing the complete software stack required to manage and use such
machines will require that a large number of different actors succeed
in going in the same direction and share the burden.
Nobody and no company can sustain all the required developments at
reasonable cost.
No company has the time and complete expertise to do it alone.
I hope collectively we can do it. This is not even sure as I can see today.

Following your logic, you can claim  "why such useless hardware
complexity? Do something simpler."
Here we have a problem, we cannot change the constants and laws of
physics, then we face the inevitable choice of massive parallelism,
complex memory hierarchies, complex micro architectures, complex
interconnects, variable elements, failing elements, ...
Quite some fun ahead in fact.

And I can promise you, the hardware designers are not lazy or short of
inspiration and they also have a growing infinitude of challenges.

Some people argue that some magic tools will decompose and tune the
programs automatically, then why you need performance tools in fact?
First this is will be done at the price of loosing an enormous part of
the potential, secondly the compilers will probably require extensive
support from the hardware counters to be somewhat effective. Most of
us target reasonable scalability, cannot afford to reach only 20% of
peak of anything.

A dream without some breakthrough on the tools side.

This is where we need advanced performance tools, tools that permit to
the largest amount of developers,
to understand how the architectures really work. Not how naively we
think they should work, but like they really work.

Theory and reality are not good friends, it's rare to meet them together.
We cannot afford that only some too rare specialists can do an always
partial tuning, I am sure they also have some limits at least time.
I am sure as soon the advanced tools will expose in the right form the
real problems to the developers, they will find innovative solutions.
Can you imagine a modern medicine without scanners ,radios, all the
sources of information on your body?

For us this is exactly the same thing, we desperately need advanced
performance tools, not one but many to attack the problems from
different angles.
An the tools should be easy to use, reliable, flexible, predictable,
ready to use when I need them, standard, installed everywhere and in
particular on the new platforms as soon they appear, ...
The tools need to hide the complexity when I need it, and expose it if required.
The tools will always be behind the requirements but I hope not too far.
I prefer tools that adapt to me than the opposite.


But I am realistic, I don't need perfect tools, I need tools I can
invest in learning and progressing a long time with them.

That's why also meanwhile the cost of development, many developers
ended up developing their own performance tools.
This is my case, spending more time to develop the tools I need than
using them, I have no choice today, but this is unsustainable now.
The current state of what is available is not what is required, not
even close to minimal of what I needed 5 years ago.


What Stephane is developing, is layer 1 of what we need, something
that hides most of the complexity of the hardware counters, and this
is not the fault of Stephane if this is very complex. This is not even
the fault of the hardware designers. In fact we ask them for more
complexity, to at least better support the virtualization and multi
users multi usages environments and ...
Naturally complexity should be managed and controlled, and I am an
ardent defender of simplification, but not to the point of suppressing
the functionalities even if they target today some rare advanced
users, tomorrow this could be common case.
The people developing the layers 2,3,4,.. of the performance tools,
all expect the under layers to be simple, flexible, stable, robust and
offer what they require.
Simple does not mean trivial, whatever the complexity of the API of
perfmon2, it will be 1 or 2 order of magnitude simpler than if  we had
to program those hardware counters directly in our programs. And stop
claiming counting or RDTSC is sufficient.

In fact most users will never see the perform2 API, just some tools
developers or advanced users pushing the limits of the technologies.
The guys that understand the hardware counters intricacies will find
the perform2 API trivially simple.

The performance tools need to offer to a large variety of different
users with a large variety of different expertises and a large variety
of different situations the best chance to approach some reasonable
optimal level at the cost they decide is justified by them.
There is room for lot of tools as soon they have some common ground
and preferably interoperability.

Then please consider helping Stephane to deliver a viable, supported
perform2 in all standard linux releases.

This is not only important for the performance, but this is also
important for many others reasons:
1: power consumption optimization, probably the companies you work for
are interested in this.
2: debugging and diagnosing those enormous machines.
In fact those 2 problems become even more important than pure code
tuning in some cases.
The hardware counters and tools also offer good opportunities to
progress on those topics.

Now what we need:

I definitively don't want to instrument my codes, I am sure I will
continue, I hope this will just be rare justified cases.

You will say I am lazy, maybe, but I have some obligation of productivity.
Then if with sampling I can obtain informations in minutes, why I
would need to instrument, recompile, and rerun my code?
By the way, sometimes you need to tune some codes you don't know and
or don't access the source code.
Yes some people work with codes without the sources and can do
important tunings that can do significant productivity gains.
How many iterations or time you need?

With sampling in 1 run if I can attach/detach and or use system wide,
then I can capture and correlate lot of set of counters.
Sometimes they can be measured independently, sometimes you need high
frequency multiplexing, sometimes I am obliged to tune and monitor the
system for a code I cannot instrument, sometimes the run is so long
than I have only 1 chance to run the program,

sometimes I need at same time to do system wide and process monitoring.
And I can probably give tens of very different scenarios where
counting is ridiculously insufficient, where instrumentation is
impossible.
And whatever perform2 offers, it will stay a hard problem for me to
correlate all the sources of measures and get the useful and valid
informations in that ocean of numbers. And I promise, I like numbers,
but graphics would be better.
Without perform2 things are much simpler, I can globally do nothing
because I am not expert in crystal ball analysis.


We can spend hours and hours convincing you this is required but I
think you need to look the problem differently.
Imagine, I spend hours and hundreds of mails discussing why you have
implement such a complex linux OS,
why are you using so much different structures in place of 1? ,... blah blah,...
I imagine you will make the comments that I am not a linux kernel
expert, and you are right.
And meanwhile I worked since 25 years on many others kernels,  you are
still right.
My obsolete expertise is useless to you and lkml and even that does
not qualify me because
I have not spent the hundreds of hours required to just start to be
serious on lkml.

But as linux kernel experts, you have no idea what means tuning a
massive SMP machine,
what means programming and tuning a MPI job of 1000+ nodes and
programming and tuning a PS3 processor,
and programming and tuning a MPI cluster of OpenMP nodes using some
accelerators to achieve 1Pflops sustained.
All those machines run or will run linux, then why you don't care?

Because you have not have one at home?
Buy a PS3 and try to do a 200Mflops FFT on it.
Can you explain to me what qualify you to pretend you can understand
what is useful and not useful for us?
How you will judge?
Number of M$?, Number of desperate developers?,something useful or fun?




I return the problem: can you do it or not?

If not, what would be required to do it rapidly?

Some funding,collaboration,trainings,coordination,...?

Be open, we will help you, but implement the thing rapidly, this is so
crucial to us..


Stephane is exposed to many of the people that are confronted to the
challenges I just described above.
He had the exceptional chance to meet many of the best experts in
performance in most of the major companies that probably cover all the
businesses.
He had the chance and pain to be obliged to work with many very
different processors and architectures.
He had the talent and the multi years patience and perseverance to
work and fight for us, not for him, even if he probably likes his
baby.
I can assure you, he is not lazy as some of you claimed imprudently.

I can assure you this domain is horribly large and subtle, far beyond
you can think.


I probably underestimate the challenges your group face, like exactly
you underestimate ours.
But I will never underestimate your efforts and exceptional talents.
And I should thank warmly your group to have offered us this
opportunity of the road to Eflops machines.

Clearly without linux we would not be there.
You are a key contributor to that vision, this is more important for
the humanity that you could understand.

Is not it important to predict the storms, hurricanes, tsunami,...?
Is not it important to discover many new drugs to prepare to fight H5N1?

Is not it important to have Google?

Is not it important to have automatic real time translation, to be
able to speak one day all together?
Is it not important to understand Global Warming?
If you think you can do that with a PC? You are welcome to show us.
No, for some problems you need 1Pflops ,1 Eflops or more
No, you need hundreds of thousands of the best scientists on the
planet trying to push the limits, there are thousands of problems to
solve.

Never heard about ITER,SKA,CERN,...?
In all cases you need tuned machines, because you cannot afford
wasting the electricity, or waiting 10 more years.


Then your role today is to offer us a way to continue our progression,
please don't stall us.

This will be very hard for you, I have no doubt, and for us, and for
the many people involved from close to far.
But many of the key problems of our society can only be solved with
those HPC machines, sorry


LOOK AT THE BIG PICTURE

I will encourage all people depending on performance tools and
suffering of lack of generally available high performance
profilers to manifest their desire for better linux support for
performance tools.

Please encourage Stephane, to continue the hard work, and help him to
succeed for us in integrating perform2.
Stephane is very open to major rewriting, if required for any valid
reason, but stop to ask for extreme truncation of functionalities.
The state of the code is not an accident, this is the result of a long
and progressive maturation shared with many people.

To be a little productive in this mail I want to give an example of
something that would be interesting to have.
This is naturally a trivial example, in fact I will not explain what
the counters means in detail and how t interpret, this is not useful
here.
Just understand this is the result of sampling and multiplexing, I
report 6 different counters with different frequencies of sampling.
Why different sampling frequencies? Because some events are very
frequent and others rares.
Some rare events can have a huge impact on efficiency, I need to
quantify their impact then get optimal resolution.
I need to capture the maximum of information in 1 run because I cannot
repeat the experiment.
I want to understand how my loops behave, one by one, because I will
tune one by one, from the most promising to least.
I will naturally collect the clock,caches,tlb,stall rate,bus
activities,flops,exceptions,... the maximum I can do in one complete
or partial run.
I want to take 1 hour sample at different moments of the life of the
program to study how the counters evolve in time.
I need to be normal user and my administrator need some counters to
monitor the global system, also done by multiplexing.
By the way the nodes need careful intrusion control and
synchronization to minimize the pollution on my MPI sensitive code.
This is not exact counting for sure,because of sampling and low
frequency I use to reduce the pollution, but this turn out to be
extremely productive in capturing all performance problems and
offering clear understanding of very subtle problems that where
previously undetectable.
I can expose percentage time spent in the loop, instruction rate, the
stall rate of the loop, and the correlation with others counters will
trigger a large variety of situations/improvements.

If I tune a loop that is 20% in middle of something very large, I can
precisely measure the benefit or degradation of any transformation
The key of success : multiplexing the largest number of valid
counters. Valid means , experience proved sometimes useful by a large
range of users.
I will try for sure to reduce the set of counters and increase the
frequency of sampling while maintaining the level of intrusion, but
generally the first pass is sufficient in most situations because it
is more important to have lot of counters to correlate that few
counters at ultra high frequency, I said generally.
In fact what I would like to obtain is some systematization of that
mechanism for regression analysis.
Imagine,I have something consuming less than 1 percent and reporting
tens of counters of any runs of my large programs.
I would be delighted to have some tool to collect and post analyze all
the variations.
One day my code is 20% slower , it is clear some of those columns will
expose precisely why.
Observe I coded no lines to achieve that dream.
This is critical because I will not be obliged to do 20 runs to
reproduce again.
I will not fix 100% of all problems, but my success rate is improved
by an enormous factor and that whatever the code is doing.
Imagine you have hundreds of nodes, you think they are all identical
mathematical objects? NO
The temporal and spatial variations could be crucial information to
collect and exploit.
You can observe that 1 or 2 nodes are systematically 5% slower,
probably interesting to fix that.
And you think this interest ONLY the HPC guys?
I am sure this will help you to anticipate many hardware problems,
most problems have subtle performance symptoms
that it would be interesting to capture to avoid the crash.
We need some software infrastructure, this can only be built above
some rich and standard low level API to capture the best of the
counters, whatever they are or will become, we will push the hardware
designer to add more, much more. But why would they spend energy to
add something that nobody use?
The sooner we have it, the better. There is lot of work to add above
permon2 or PAPI or others layers, and the processors, chipsets, ...

---------------------------------------------------------------------------------------------------------------

One example of capture with few counters to expose the concept:
column 1 is address
column 2 is cycles
column 3 is cycles : hardwired in core2
column 4 is instructions rate
column 5 is memory bus cycles
column 6 is cache miss rate
column 7 stall rate information
--------------------------------------------------------------------------------------------------------------

_ 423d54  14979   19282   20482    158    9187    282          mov
(%r9,%r15,1),%r10d
_ 423d58  23124 109815  114371   265  54809   3259          mov
0x4(%r9,%r15,1),%r11d
_ 423d5d   7135     8379     8888     40    4151     116
movss (%rdi,%r14,1),%xmm1
_ 423d63 15501    40062   41924     78  19540     977          mulss
%xmm0,%xmm1
_ 423d67 49814    48065   50873   330   21451    509          movss
%xmm1,(%rdi,%rax,1)
_ 423d6c 47365    58046   60958   159   29862   1036         mov
%r10d,(%r9,%rdx,1)
_ 423d70  3765      5132     5386     15    3052     103         mov
(%rdi,%r13,1),%r10d
_ 423d74 75911  130227 136796    318  62672   2538         mov
%r11d,0x4(%r9,%rdx,1)
_ 423d79  6623      9732   10444     32    5203     148         add $0x8,%r9
_ 423d7d 10575      8214    8663     36    3681       88         mov
%r10d,0x67a500(%rdi)
_ 423d84 16072    23604  24715     42   11284     371         mov
(%rdi,%r12,1),%r10d
_ 423d88  5343     33126  34584   185   16226     938         mov
%r10d,0x684140(%rdi)
_ 423d8f 14227     22018  23249     80   10950     370         mov
(%rdi,%rbx,1),%r10d
_ 423d93 10917    34384  35815   168   17132     924         mov
%r10d,0x68dd80(%rdi)
_ 423d9a  9991     13744  14676     96    7077     202         add $0x4,%rdi
_ 423d9e       0            8         9       0         0         0
     cmp %rcx,%rdi
_ 423da1    951      2611    2677     24       14        11         jl 423d54

--------------------------------------------------------------------------------------------------------------

Then please help Stephane to integrate the complete perfmon2 feature
set in standard linux kernels

Patrick DEMICHEL
