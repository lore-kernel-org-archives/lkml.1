Return-Path: <linux-kernel-owner+w=401wt.eu-S1752365AbXA0T3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365AbXA0T3U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 14:29:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752366AbXA0T3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 14:29:20 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:44346 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364AbXA0T3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 14:29:19 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Auke Kok <auke-jan.h.kok@intel.com>
Cc: linux-pci maillist <linux-pci@atrey.karlin.mff.cuni.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: Re: Possible regression: MSI vector leakage since 2.6.18-rc5ish (Unable to repeatedly allocate/free MSI interrupt)
References: <45BA82DA.6050201@intel.com>
	<m1bqkku8bp.fsf@ebiederm.dsl.xmission.com> <45BBA2DD.50609@intel.com>
Date: Sat, 27 Jan 2007 12:28:40 -0700
In-Reply-To: <45BBA2DD.50609@intel.com> (Auke Kok's message of "Sat, 27 Jan
	2007 11:07:09 -0800")
Message-ID: <m1veiss1zr.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Auke Kok <auke-jan.h.kok@intel.com> writes:

> I highly doubt it - I've seen the problem even on this weeks git on
> x86_64. Moreover, I'm at home for the weekend and testing resources are limited
> :). I'll see what I can do

Thanks.  There may be more to it than what I suspect, but I could not
reproduce it on x86_64.

Now I may have missed something as I optimized my tested based on the fact
that close and open are triggered when you up and down a network interface.
so I didn't do a complete rmmod, (since my network driver wasn't modular).

Since you have seen this on x86_64 I will look deeper.  

Eric
