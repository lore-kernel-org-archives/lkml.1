Return-Path: <linux-kernel-owner+w=401wt.eu-S1755647AbZCAMPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647AbZCAMPd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 07:15:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752776AbZCAMPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 07:15:24 -0500
Received: from hera.kernel.org ([140.211.167.34]:45319 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752034AbZCAMPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 07:15:24 -0500
Subject: Re: [git-pull -tip] x86: Basic AMD Support for performance counters
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       x86 maintainers <x86@kernel.org>, Paul Mackerras <paulus@samba.org>
In-Reply-To: <20090301120028.GA16057@elte.hu>
References: <1235756278.3914.9.camel@localhost.localdomain>
	 <20090228094018.GF12095@elte.hu> <20090228134434.GA32473@elte.hu>
	 <20090301083616.GA1742@elte.hu>
	 <1235904087.3213.3.camel@localhost.localdomain>
	 <20090301113010.GA1203@elte.hu> <1235907690.19758.1.camel@ht.satnam>
	 <20090301115821.GA15716@elte.hu>  <20090301120028.GA16057@elte.hu>
Content-Type: text/plain
Date: Sun, 01 Mar 2009 17:44:40 +0530
Message-Id: <1235909680.19758.11.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-03-01 at 13:00 +0100, Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > still crashes in a similar way.
> > 
> > hm, this box has nmi_watchdog=2, and the NMI watchdog uses the 
> > PMU too - will disable that.
> 
> yep, nmi_watchdog=0 solves the regression. You ought to be able 
> to reproduce the same problem by adding nmi_watchdog=2 on your 
> testbox.
> 

One of my AMD box is broken because of hot weather So now I have only
one AMD box left.
By adding nmi_watchdog=2 does not effect my AMD 64 bit box.
But any how I will fix the interrupt handler so that you can receive
interrupts on your box.

Thanks,
--
JSR



