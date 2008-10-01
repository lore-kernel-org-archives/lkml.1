Return-Path: <linux-kernel-owner+w=401wt.eu-S1753593AbYJAAPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593AbYJAAPR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 20:15:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753072AbYJAAPC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 20:15:02 -0400
Received: from waste.org ([66.93.16.53]:45520 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752124AbYJAAPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 20:15:00 -0400
Subject: Why is arch/x86/kernel/acpi/sleep.c:temp_stack 10k?
From: Matt Mackall <mpm@selenic.com>
To: Ingo Molnar <mingo@elte.hu>, Pavel Machek <pavel@suse.cz>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Content-Type: text/plain
Date: Tue, 30 Sep 2008 19:12:37 -0500
Message-Id: <1222819957.13453.15.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've got:

#if defined(CONFIG_SMP) && defined(CONFIG_64BIT)
static char temp_stack[10240];
#endif

and:

#ifdef CONFIG_SMP
        stack_start.sp = temp_stack + 4096;
#endif

..which suggests we use at most 4k of the stack?

-- 
Mathematics is the supreme nostalgia of our time.

