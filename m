Return-Path: <linux-kernel-owner+w=401wt.eu-S1754651AbZAZTle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651AbZAZTle (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 14:41:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754232AbZAZTlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 14:41:22 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35923 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754116AbZAZTlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 14:41:21 -0500
Date: Mon, 26 Jan 2009 11:40:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, hpa@zytor.com
Subject: Re: [git pull] x86 fixes
Message-Id: <20090126114038.a2f6606f.akpm@linux-foundation.org>
In-Reply-To: <20090126192016.GA1211@elte.hu>
References: <20090126171723.GA32030@elte.hu>
	<20090126110539.2000cd30.akpm@linux-foundation.org>
	<20090126192016.GA1211@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jan 2009 20:20:16 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Mon, 26 Jan 2009 18:17:23 +0100
> > Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > Rusty Russell (2):
> > >       ...
> > >       work_on_cpu: Use our own workqueue.
> > 
> > wtf?
> 
> an x86 fix depends on it:
> 
> 7285908: cpufreq: use work_on_cpu in acpi-cpufreq.c for drv_read and drv_write
> 

Right.  And these are currently under active (albeit rather slow) discussion.

The changelogs suck, nobody can be assed actually telling us what the
bug is and the patches just casually toss yet another gaggle of kernel
threads into there.
