Return-Path: <linux-kernel-owner+w=401wt.eu-S1756568AbYFBX4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756568AbYFBX4W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 19:56:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754858AbYFBX4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 19:56:14 -0400
Received: from smtprelay10.ispgateway.de ([80.67.29.24]:45085 "EHLO
	smtprelay10.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638AbYFBX4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 19:56:13 -0400
From: Ingo Oeser <ioe-lkml@rameria.de>
To: Max Krasnyansky <maxk@qualcomm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Inquiry: Should we remove "isolcpus= kernel boot option? (may have realtime uses)
Date: Tue, 3 Jun 2008 01:55:57 +0200
User-Agent: KMail/1.9.9
Cc: Paul Jackson <pj@sgi.com>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, "Derek L. Fults" <dfults@sgi.com>,
       devik <devik@cdi.cz>, Dimitri Sivanich <sivanich@sgi.com>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       Emmanuel Pacaud <emmanuel.pacaud@univ-poitiers.fr>,
       Frederik Deweerdt <deweerdt@free.fr>, Ingo Molnar <mingo@elte.hu>,
       Matthew Dobson <colpatch@us.ibm.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, rostedt@goodmis.org,
       Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Paul Menage <menage@google.com>, "Randy.Dunlap" <rddunlap@osdl.org>,
       suresh.b.siddha@intel.com, Thomas Gleixner <tglx@linutronix.de>
References: <20080601213019.14ea8ef8.pj@sgi.com> <1212446707.6269.26.camel@lappy.programming.kicks-ass.net> <48447C75.8040203@qualcomm.com>
In-Reply-To: <48447C75.8040203@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806030156.00155.ioe-lkml@rameria.de>
X-Df-Sender: 849595
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Max,
Hi Peter,

On Tuesday 03 June 2008, Max Krasnyansky wrote:
> Ingo, I just wanted to elaborate on what Peter is saying. That CPU will still
> have to be _booted_ properly. It may be used for hard- and soft- interrupt
> processing, workqueues (internal kernel queuing mechanism) and kernel timers.

Oh! Didn't know that user process scheduling is so much 
> In your particular case you're much much much better off with doing
> 	echo 0 > /sys/devices/system/cpuN/online
> either during initrd stage or as a first init script.
> That way bad cpu will be _completely_ disabled.

The initrd is from the distribution. I have no sane way to change it
fast and permanent. Can I change the initrd and still have a certified
RHEL or SLES? Are there initrd hooks, which survive packet installation?

I would really appreciate some way to keep the kernel from using 
a CPU at all to do fault isolation. If possible not even booting it.

Bootparameters survived all distro fiddling so far. I love them!

Try to convince a hardware vendor, that you don't have a software bug.
Try to convince him that you didn't break the hardware by swapping it around.

So I'll ACK removing isolcpus, if we get a better replacement boot option.


Best Regards

Ingo Oeser
