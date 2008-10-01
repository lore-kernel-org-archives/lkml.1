Return-Path: <linux-kernel-owner+w=401wt.eu-S1754165AbYI3Xtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165AbYI3Xtk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 19:49:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752124AbYI3Xtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 19:49:33 -0400
Received: from xenotime.net ([66.160.160.81]:57715 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752052AbYI3Xtc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 19:49:32 -0400
Date: Tue, 30 Sep 2008 17:07:58 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] x86: mtrr_cleanup update command line
Message-Id: <20080930170758.a4e88e28.rdunlap@xenotime.net>
In-Reply-To: <48E2B920.2020503@zytor.com>
References: <1222817380-29481-1-git-send-email-yhlu.kernel@gmail.com>
	<20080930165739.7847be37.rdunlap@xenotime.net>
	<48E2B920.2020503@zytor.com>
Organization: YPO4
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Sep 2008 16:41:20 -0700 H. Peter Anvin wrote:

> Randy Dunlap wrote:
> > 
> > E.g., the "apic" entries are not grouped together and these mtrr entries should
> > not be grouped together unless they all begin with "mtrr", which is an option here:
> > they could be renamed to "mtrr-cleanup" and "mtrr-nocleanup".
> > And "disable_mtrr_trim" could be renamed to "mtrr-notrim".
> > 
> 
> That does collide with the (not always kept) convention of prefixing 
> "no" to disable a boolean option, though.

True.  Then they just need to be listed in alpha order, please.

---
~Randy
