Return-Path: <linux-kernel-owner+w=401wt.eu-S1751959AbZHZRKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959AbZHZRKe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 13:10:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750862AbZHZRKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 13:10:34 -0400
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:59728 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750802AbZHZRKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 13:10:33 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Au4EAGcHlUpMROOX/2dsb2JhbACBU9dWhBoF
Date: Wed, 26 Aug 2009 13:10:18 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
       Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, laijs@cn.fujitsu.com, rostedt@goodmis.org,
       jiayingz@google.com, mbligh@google.com, lizf@cn.fujitsu.com,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [PATCH 08/12] add trace events for each syscall entry/exit
Message-ID: <20090826171018.GD21456@Krystal>
References: <20090825141547.GE6114@nowhere> <20090825160237.GG4639@cetus.boeblingen.de.ibm.com> <20090825162004.GA25058@Krystal> <20090825165912.GI6114@nowhere> <20090825173107.GJ6114@nowhere> <20090825183119.GC2448@Krystal> <1251270602.7538.1228.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1251270602.7538.1228.camel@twins>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 13:09:03 up 8 days,  3:58,  2 users,  load average: 0.18, 0.27,
	0.28
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Tue, 2009-08-25 at 14:31 -0400, Mathieu Desnoyers wrote:
> > For instance, some
> > proprietary Linux driver does very odd things with system calls within
> > kernel threads, like invoking them with int 0x80.
> 
> So who is going to send the x86 patch to make int 0x80 from kernel space
> panic the machine? :-)

I'm pretty sure ATI or Nvidia already cooked something like this in the
past. Let's not bother too much with the proprietary aspect. Tracing
internal kernel invocations of sys_*() is actually the main point I was
trying to come to.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
