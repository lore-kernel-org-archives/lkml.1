Return-Path: <linux-kernel-owner+w=401wt.eu-S1761469AbXJMAds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761469AbXJMAds (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 20:33:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760258AbXJMAdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 20:33:36 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33102 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760659AbXJMAdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 20:33:35 -0400
Date: Fri, 12 Oct 2007 17:32:37 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>
cc: Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: arch merge fallout.
In-Reply-To: <20071013001153.GA30688@redhat.com>
Message-ID: <alpine.LFD.0.999.0710121731110.6887@woody.linux-foundation.org>
References: <20071012035743.GA12897@redhat.com>
 <alpine.LFD.0.999.0710112103240.6887@woody.linux-foundation.org>
 <20071012182504.GA9222@redhat.com> <alpine.LFD.0.999.0710121457230.6887@woody.linux-foundation.org>
 <20071012221253.GB4290@redhat.com> <alpine.LFD.0.999.0710121542030.6887@woody.linux-foundation.org>
 <20071012225222.GD4290@redhat.com> <alpine.LFD.0.999.0710121608460.6887@woody.linux-foundation.org>
 <20071013001153.GA30688@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 12 Oct 2007, Dave Jones wrote:
> 
> $ git log --follow arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c
> fatal: ambiguous argument 'arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c':
> unknown revision or path not in the working tree.
> Use '--' to separate paths from revisions

Duh. You need to use the current name, of course.

	git log --follow arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c


gives me the proper output.

> Is what I'm seeing above indicative of this bug ? Or something else?  
> Adding -p or --stat makes no difference at all.

Try it with the right path.

		Linus
