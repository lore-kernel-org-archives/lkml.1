Return-Path: <linux-kernel-owner+w=401wt.eu-S1752870AbXIHKVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870AbXIHKVR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 06:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751156AbXIHKVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 06:21:04 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:39574 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750903AbXIHKVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 06:21:01 -0400
Date: Sat, 8 Sep 2007 11:29:22 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jesse Barnes <jesse.barnes@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Intel Memory Ordering White Paper
Message-ID: <20070908112922.3fd41adc@the-village.bc.nu>
In-Reply-To: <200709071526.51169.jesse.barnes@intel.com>
References: <200709071526.51169.jesse.barnes@intel.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Sep 2007 15:26:50 -0700
Jesse Barnes <jesse.barnes@intel.com> wrote:

> FYI, we just released a new white paper describing memory ordering for 
> Intel processors:
> http://developer.intel.com/products/processor/manuals/index.htm
> 
> Should help answer some questions about some of the ordering primitives 
> we use on i386 and x86_64.

Nice - but it appears to be 64bit only - and indeed it appears to be
untrue for real 32bit because of the Pentium Pro fencing errata.

The kernel also runs on IDT Winchip, Cyrix and AMD processors not all of
which have exactly the same behaviour (the IDT Winchip as we run it
profoundly differs)

Alan
