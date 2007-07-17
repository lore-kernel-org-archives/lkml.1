Return-Path: <linux-kernel-owner+w=401wt.eu-S933910AbXGQQtD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933910AbXGQQtD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 12:49:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756425AbXGQQsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 12:48:53 -0400
Received: from gw.goop.org ([64.81.55.164]:58639 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756946AbXGQQsv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 12:48:51 -0400
Message-ID: <469CF2BC.3000306@goop.org>
Date: Tue, 17 Jul 2007 09:47:56 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: john.blackwood@ccur.com
CC: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@xensource.com>,
       Andi Kleen <ak@suse.de>, Roland McGrath <roland@redhat.com>,
       bugsy@ccur.com, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Reading the VDSO area - i386
References: <469CECFE.6060408@ccur.com>
In-Reply-To: <469CECFE.6060408@ccur.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

John Blackwood wrote:
> I was doing some tests that attempt to read the VDSO area of a
> task through either the /proc/pid/mem or ptrace(PTRACE_PEEKTEXT,
> ...) interfaces, and it seems that when the CONFIG_COMPAT_VDSO kernel
> parameter is enabled, we can no longer successfully read the VDSO area
> on i386 kernels.

Thanks.  Someone else noticed this recently, and posted a near-identical
patch.  But I can't seem to find it right now...

Andrew, Andi: do you remember something like this passing by?

    J
