Return-Path: <linux-kernel-owner+w=401wt.eu-S1757482AbXERGbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482AbXERGbQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 02:31:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752893AbXERGbE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 02:31:04 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:39830 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752652AbXERGbC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 02:31:02 -0400
Date: Fri, 18 May 2007 08:28:13 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Rik van Riel <riel@redhat.com>
cc: righiandr@users.sourceforge.net, LKML <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org, ak@suse.de
Subject: Re: signals logged / [RFC] log out-of-virtual-memory events
In-Reply-To: <464C9D82.60105@redhat.com>
Message-ID: <Pine.LNX.4.61.0705180825280.3231@yvahk01.tjqt.qr>
References: <464C81B5.8070101@users.sourceforge.net> <464C9D82.60105@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 17 2007 14:22, Rik van Riel wrote:
> Andrea Righi wrote:
>> I'm looking for a way to keep track of the processes that fail to allocate
>> new
>> virtual memory. What do you think about the following approach (untested)?
>
> Looks like an easy way for users to spam syslogd over and
> over and over again.
>
> At the very least, shouldn't this be dependant on print_fatal_signals?

Speaking of signals, everytime I get a segfault (or force one with a test
program) on x86_64, the kernel prints to dmesg:

fail[22278]: segfault at 0000000000000000 rip 00000000004004b8 rsp
00007ffff7ecda50 error 6

I do not see such on i386, so why for x86_64?


	Jan
-- 
