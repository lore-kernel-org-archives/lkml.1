Return-Path: <linux-kernel-owner+w=401wt.eu-S1756140AbZGBGuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140AbZGBGuu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 02:50:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752880AbZGBGuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 02:50:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55264 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754767AbZGBGue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 02:50:34 -0400
Date: Wed, 1 Jul 2009 23:48:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, v2] x86: Fix printk call in print_local_apic()
Message-Id: <20090701234848.03dfa601.akpm@linux-foundation.org>
In-Reply-To: <20090702062847.GB23277@elte.hu>
References: <4A4C3410.8080704@kernel.org>
	<alpine.LFD.2.01.0907012119370.3380@localhost.localdomain>
	<alpine.LFD.2.01.0907012126371.3380@localhost.localdomain>
	<4A4C43BC.90506@kernel.org>
	<20090702061254.GA23277@elte.hu>
	<20090702062847.GB23277@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Jul 2009 08:28:47 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> +		printk(KERN_CONT "%08x", i, apic_read(base + i*0x10));

oop - compile it first ;)

There was some talk about teaching the lib/hexdump.c code to be able to
take a caller-provided give-me-another-byte function pointer.  This is
the first potential user of such a thing which I recall seeing, so it's
probably good that we didn't do it ;)

