Return-Path: <linux-kernel-owner+w=401wt.eu-S1757353AbYH3VPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757353AbYH3VPa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 17:15:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754829AbYH3VPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 17:15:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46321 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754519AbYH3VPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 17:15:19 -0400
Date: Sat, 30 Aug 2008 14:14:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Matthias Urlichs <matthias@urlichs.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Regression] sshd hangs on close
Message-Id: <20080830141431.7bb34048.akpm@linux-foundation.org>
In-Reply-To: <200808302228.58255.rjw@sisk.pl>
References: <g9b39n$4et$1@ger.gmane.org>
	<200808302228.58255.rjw@sisk.pl>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Aug 2008 22:28:57 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> [Adding CCs]
> 
> On Saturday, 30 of August 2008, Matthias Urlichs wrote:
> > "top" sees multiple instances of:
> > 
> >  6008 root      20 3184 D    0   0:00.06 flush_cpu sshd: root@pts/13            
> > 
> > This is 2.6.27rc5, preemption and tickless turned on, on a 4-CPU machine.
> > (OK, two hyperthreaded ones :-P) strace() shows that this happens on the
> > last close of its /dev/ptmx file descriptor, which hangs.
> > 
> > I'll do a bisect early next week unless somebody else identifies a likely
> > suspect.
> > 

Please do `echo w > /proc/sysrq-trigger', send the resulting trace.
