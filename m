Return-Path: <linux-kernel-owner+w=401wt.eu-S1752470AbYASFHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470AbYASFHn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 00:07:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750773AbYASFHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 00:07:34 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59162 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722AbYASFHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 00:07:33 -0500
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Announce] Development release 0.1 of the LatencyTOP tool
From: Andi Kleen <andi@firstfloor.org>
References: <4790E3A6.7060807@linux.intel.com>
Date: Sat, 19 Jan 2008 06:07:28 +0100
In-Reply-To: <4790E3A6.7060807@linux.intel.com> (Arjan van de Ven's message of "Fri\, 18 Jan 2008 09\:36\:38 -0800")
Message-ID: <p73lk6m9ze7.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven <arjan@linux.intel.com> writes:

> The Intel Open Source Technology Center is pleased to announce the
> release of version 0.1 of LatencyTOP, a tool for developers to visualize
> system latencies.

Just for completeness -- Linux already had a way to profile latencies
since quite some time. It's little known unfortunately and doesn't
work for modules since it's a special mode in the old non modular kernel
profiler. 

You enable CONFIG_SCHEDSTATS and boot with profile=sleep and then you can
use the readprofile command to read the data. Information can be reset with 
echo > /proc/profile

There's also a profile=sched to profile the scheduler which works even
without CONFIG_SCHEDSTATS

Latencytop will be probably a little more user friendly though.

-Andi
