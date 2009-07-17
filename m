Return-Path: <linux-kernel-owner+w=401wt.eu-S1757969AbZGQWh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757969AbZGQWh4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 18:37:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757929AbZGQWhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 18:37:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40151 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757905AbZGQWhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 18:37:55 -0400
Date: Fri, 17 Jul 2009 15:37:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tj Hariharan <tj.physicist@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: kernel stuck at trying to change CPU resolution.
Message-Id: <20090717153742.d9144d91.akpm@linux-foundation.org>
In-Reply-To: <20090626111652.GA7244@TjsLaptop>
References: <20090626111652.GA7244@TjsLaptop>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jun 2009 07:16:53 -0400
Tj Hariharan <tj.physicist@gmail.com> wrote:

> 
> Hi, I have a Pentium-M 1.86GHZ processor Laptop. Standard DELL Latitude
> D610. I ran the 2.6.31-rc1 kernel (updated tree as of 10 minutes ago).
> The kernel gets stuck at the message saying "Switching to High
> resolution mode on CPU0" after about 10 minutes it goes to the next
> step, but then continues to get stuck. There is no log, as presumable
> this is happening before the kernel fully initialises the harddrive and
> passes control to user mode. I am running a non modular kernel with no
> major changes made to my configuration since 2.6.27. I have never had
> any issues thus far. Since I am using a laptop I am unable to access the
> sysrq key (which in my case is not prnt screen, but Fn+PrintScreen, and
> Fn key is not read by kernel at all, even after full boot and under
> normal conditions). Thank you for your time. I have also attached my
> config file. 
> 

Thanks for the report.

Is this regression still present in 2.6.31-rc3 or later?

If so, do you know if the bug was present in 2.6.30/29/28?
