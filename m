Return-Path: <linux-kernel-owner+w=401wt.eu-S966002AbXCPXcO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966002AbXCPXcO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 19:32:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966004AbXCPXcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 19:32:14 -0400
Received: from www.osadl.org ([213.239.205.134]:37400 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S966002AbXCPXcL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 19:32:11 -0400
Subject: Re: [BUG] 2.6.21-rc1,2,3 regressions on my system that I found so
	far
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200703161230.03712.maximlevitsky@gmail.com>
References: <200703161230.03712.maximlevitsky@gmail.com>
Content-Type: text/plain
Date: Sat, 17 Mar 2007 00:39:01 +0100
Message-Id: <1174088342.13341.340.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-16 at 12:30 +0200, Maxim Levitsky wrote:
> Mar 14 00:22:23 MAIN kernel: [    2.072875] caller is check_tsc_sync_source+0x1d/0x100
> Mar 14 00:22:23 MAIN kernel: [    2.072878]  [show_trace_log_lvl+26/48] show_trace_log_lvl+0x1a/0x30
> Mar 14 00:22:23 MAIN kernel: [    2.072931] checking TSC synchronization [CPU#0 -> CPU#1]:
> Mar 14 00:22:23 MAIN kernel: [    2.092922] Measured 72051818872 cycles TSC warp between CPUs, turning off
> 
> It looks clear that preempt is enabled all the way in second cpu initialization, ( I think that at least in check_tsc_sync_source, it should be disabled,
> shouldn't it ? )

This should be fixed by commit d04f41e35343f1d788551fd3f753f51794f4afcf

	tglx



