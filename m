Return-Path: <linux-kernel-owner+w=401wt.eu-S1754639Ab0ATW1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639Ab0ATW1b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 17:27:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753361Ab0ATW1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 17:27:30 -0500
Received: from tomts13.bellnexxia.net ([209.226.175.34]:42703 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753146Ab0ATW13 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 17:27:29 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArcEAFcOV0uuWOiG/2dsb2JhbACBRtg5hDYEjVE
Date: Wed, 20 Jan 2010 17:27:26 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org,
       rp@svcs.cs.pdx.edu
Cc: Michel Dagenais <michel.dagenais@polymtl.ca>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Robert Wisniewski <bob@watson.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>, Martin Bligh <mbligh@google.com>,
       Dominique Toupin <dominique.toupin@ericsson.com>
Subject: Ph.D. dissertation "Low-Impact Operating System Tracing"
Message-ID: <20100120222726.GA17966@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 17:15:06 up 35 days,  6:33,  5 users,  load average: 0.62, 0.31,
	0.18
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I defended my Ph.D. dissertation entitled "Low-Impact Operating System
Tracing" on December 4th, 2009. The dissertation, written in English, is
available online:

Desnoyers, Mathieu (2009), "Low-Impact Operating System Tracing". Ph.D.
dissertation, École Polytechnique de Montréal, [Online]. Available:
http://www.lttng.org/pub/thesis/desnoyers-dissertation-2009-12-v25.pdf

The resulting open source projects are:

- Linux Trace Toolkit Next Generation (LTTng), a LGPLv2.1/GPLv2 tracer
  for the Linux kernel (http://www.lttng.org)
- Userspace RCU library (liburcu), a highly-scalable user-space
  synchronization library, distributed under the LGPLv2.1 license
  (http://www.lttng.org/urcu)


Research Summary

Computer systems, both at the hardware and software-levels, are becoming
increasingly complex. In the case of Linux, used in a large range of
applications, from small embedded devices to high-end servers, the size
of the operating system kernels increases, libraries are added, and
major software redesign is required to benefit from multi-core
architectures, which are found everywhere. As a result, the software
development industry and individual developers are facing problems which
resolution requires to understand the interaction between applications
and all components of an operating system.

In this thesis, we propose the LTTng (Linux Trace Toolkit next
generation) tracer as an answer to the industry and open source
community tracing needs. The low-intrusiveness of the tracer is a key
aspect to its usefulness, because we need to be able to reproduce, under
tracing, problems occurring in normal conditions. In some cases, users
leave tracers active at all times in production, which makes the tracer
overhead definitely critical. Our approach involves the design of
synchronization primitives that meet the low-impact requirements. The
linearly scalable and wait-free RCU (Read-Copy Update) synchronization
mechanism used by the LTTng tracer fulfills these requirements with
respect to data read. A custom-made buffer synchronization scheme is
proposed to extract tracing data while preserving linear scalability and
wait-free characteristics.

By measuring the LTTng impact, we demonstrate that it is possible to
create a tracer that satisfy all the following characteristics: low
latency, deterministic real-time impact (wait-free), small impact on
operating system throughput and linear scalability with the number of
cores. Experiments on various architectures show that this tracer is
portable.

We propose a general model for superscalar multi-core systems with
weakly-ordered memory accesses to perform formal verification of the RCU
correctness and wait-free guarantees by model-checking. The LTTng
buffering scheme is also formally verified for safety and progress.
Formal verification demonstrates that these algorithms allow reentrancy
from multiple execution contexts, ranging from standard thread to
non-maskable interrupts handlers, allowing a wide instrumentation
coverage of the operating system.


Acknowledgements

Thanks to Google, IBM Research, Ericsson, Autodesk, Natural Sciences and
Engineering Research Council of Canada and Defence Research and
Development Canada for funding this research.


Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
