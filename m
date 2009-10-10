Return-Path: <linux-kernel-owner+w=401wt.eu-S1757280AbZJJKNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757280AbZJJKNA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 06:13:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755963AbZJJKM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 06:12:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:46625 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755680AbZJJKM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 06:12:58 -0400
Subject: Re: [PATCH RFC] sched: add notifier for process migration
From: Peter Zijlstra <peterz@infradead.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@linux.intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <4AD055B3.8070705@goop.org>
References: <4ACFA4C5.4020607@goop.org> <1255125738.7439.17.camel@laptop>
	 <4ACFBC98.4070701@goop.org> <1255158863.7866.25.camel@twins>
	 <4AD04E50.7060001@redhat.com> <1255166662.7866.28.camel@twins>
	 <4AD055B3.8070705@goop.org>
Content-Type: text/plain
Date: Sat, 10 Oct 2009 12:12:08 +0200
Message-Id: <1255169528.7521.3.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-10-10 at 02:36 -0700, Jeremy Fitzhardinge wrote:
> On 10/10/09 02:24, Peter Zijlstra wrote:
> > Is that a real issue? If its not supported by the early hardware virt
> > chips, tough luck, they sucked anyway :-)
> >   
> 
> Nehalem is the first Intel chip to support it, and Xen doesn't rely on
> hardware virt support anyway.

Ah, nehalem is too limited indeed :-/

A well, look at set_task_cpu(): new_rq->nr_migrations_in++;

