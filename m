Return-Path: <linux-kernel-owner+w=401wt.eu-S1751895AbZGRNnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895AbZGRNnY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 09:43:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751467AbZGRNnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 09:43:20 -0400
Received: from www.tglx.de ([62.245.132.106]:33701 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466AbZGRNnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 09:43:19 -0400
Date: Sat, 18 Jul 2009 15:42:30 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Tj Hariharan <tj.physicist@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: kernel stuck at trying to change CPU resolution.
In-Reply-To: <20090717153742.d9144d91.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.00.0907181529310.11571@localhost.localdomain>
References: <20090626111652.GA7244@TjsLaptop> <20090717153742.d9144d91.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Jul 2009, Andrew Morton wrote:
> On Fri, 26 Jun 2009 07:16:53 -0400
> Tj Hariharan <tj.physicist@gmail.com> wrote:
> 
> > 
> > Hi, I have a Pentium-M 1.86GHZ processor Laptop. Standard DELL Latitude
> > D610. I ran the 2.6.31-rc1 kernel (updated tree as of 10 minutes ago).
> > The kernel gets stuck at the message saying "Switching to High
> > resolution mode on CPU0" after about 10 minutes it goes to the next
> > step, but then continues to get stuck. There is no log, as presumable
> > this is happening before the kernel fully initialises the harddrive and
> > passes control to user mode. I am running a non modular kernel with no
> > major changes made to my configuration since 2.6.27. I have never had
> > any issues thus far. Since I am using a laptop I am unable to access the
> > sysrq key (which in my case is not prnt screen, but Fn+PrintScreen, and
> > Fn key is not read by kernel at all, even after full boot and under
> > normal conditions). Thank you for your time. I have also attached my
> > config file. 

Tj, does the kernel boot when you add "nohz=off highres=off" to the
kernel command line ?

Another thing worth a try is to add "hpet=disable" to the kernel command
line. HPET code is the major change in the timers area since 2.6.27.

Thanks,

	tglx
