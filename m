Return-Path: <linux-kernel-owner+w=401wt.eu-S1765685AbXJOUCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765685AbXJOUCd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 16:02:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758444AbXJOUCR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 16:02:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39198 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756073AbXJOUCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 16:02:16 -0400
Date: Mon, 15 Oct 2007 16:01:40 -0400
From: Dave Jones <davej@redhat.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andi Kleen <ak@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: git/cscope with x86 merge
Message-ID: <20071015200140.GB20467@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Yinghai Lu <yhlu.kernel@gmail.com>, Andi Kleen <ak@suse.de>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sam Ravnborg <sam@ravnborg.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <86802c440710151245s7d12a45fpfdaa041546d965e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440710151245s7d12a45fpfdaa041546d965e@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2007 at 12:45:27PM -0700, Yinghai Lu wrote:
 > after the merge:
 > 1. git
 > git log -p arch/x86/kernel/io_apic_64.c
 > only can show the log from the merge..., and can not get log before
 > merge for x86_64/kernel/io_apic.c
 > Any git update for that?

add --follow to your command line

 > 2. cscope
 > on x86_64, it is good to see file in arch/x86/pci/*
 > but will show other _32.c too.
 > So is it possible to change find-sources to make filter out _32.* and
 > mach-* dirs?
 
I see this as a positive thing personally.  You could regenerate the
cscope files by hand. Or maybe introduce a 'cscope_minimal' Makefile
target perhaps.

	Dave

-- 
http://www.codemonkey.org.uk
