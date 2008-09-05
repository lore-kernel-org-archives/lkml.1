Return-Path: <linux-kernel-owner+w=401wt.eu-S1753063AbYIELjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063AbYIELjS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 07:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752097AbYIELjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 07:39:05 -0400
Received: from torres.zugschlus.de ([85.214.68.41]:51732 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037AbYIELjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 07:39:04 -0400
Date: Fri, 5 Sep 2008 13:39:02 +0200
From: Marc Haber <mh+linux-kernel@zugschlus.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.26.3 mount process looping on ext3 rw remount
Message-ID: <20080905113901.GA2756@torres.zugschlus.de>
References: <20080823084228.GA21293@torres.zugschlus.de> <20080825183528.30b66f45.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080825183528.30b66f45.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2008 at 06:35:28PM -0700, Andrew Morton wrote:
> Please try to get a kernel profile while it's happening.  oprofile
> maybe, or just the plain old timer-based profiler.  There's some info
> in Documentation/basic_profiling.txt.

I'll boot my next kernel with profile=2.

> Actually, a simple alternative is to hit sysrq-P five or ten times. 
> Most of the resulting stack traces will point back at where the CPU is
> stuck.

Where are they written to? "P" in a sysrqd telnet session does not
result in anything being written to the kernel log or to dmesg.

> This gets a bit hit-or-miss if you have multiple CPUs, because the
> sysrq-p trace can land on the wrong CPU.  We recently added a sysrq-l
> which will generate a trace on all CPUS.

"l" results in the SysRq HELP being written to the kernel log, so I
guess that "recently" means "not yet in 2.6.26.3".

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Mannheim, Germany  |  lose things."    Winona Ryder | Fon: *49 621 72739834
Nordisch by Nature |  How to make an American Quilt | Fax: *49 3221 2323190
