Return-Path: <linux-kernel-owner+w=401wt.eu-S1752018AbZJKT4I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018AbZJKT4I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 15:56:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751907AbZJKT4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 15:56:07 -0400
Received: from www.tglx.de ([62.245.132.106]:37103 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248AbZJKT4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 15:56:05 -0400
Date: Sun, 11 Oct 2009 21:54:36 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arnd Bergmann <arndbergmann@googlemail.com>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Vincent Sanders <vince@simtec.co.uk>, John Kacur <jkacur@redhat.com>,
       Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@infradead.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Dmitry Torokhov <dtor@mail.ru>
Subject: Re: [patch 20/28] input: Remove BKL from hp_sdc_rtc
In-Reply-To: <200910112147.55546.arnd@arndb.de>
Message-ID: <alpine.LFD.2.00.0910112154230.9428@localhost.localdomain>
References: <20091010153314.827301943@linutronix.de> <20091010153349.884891604@linutronix.de> <200910112147.55546.arnd@arndb.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Oct 2009, Arnd Bergmann wrote:

> On Saturday 10 October 2009, Thomas Gleixner wrote:
> > cycle_kernel_lock() was added during the big BKL pushdown. It should
> > ensure the serializiation against driver init code. In this case there
> > is nothing to serialize. Remove it.
> 
> The driver still holds the BKL in its ioctl method, which should be removed
> as well if the above is true.

On my list already :)
