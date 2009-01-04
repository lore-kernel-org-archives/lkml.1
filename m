Return-Path: <linux-kernel-owner+w=401wt.eu-S1759033AbZADSJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759033AbZADSJT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 13:09:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751961AbZADSJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 13:09:09 -0500
Received: from viefep14-int.chello.at ([62.179.121.34]:45993 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751921AbZADSJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 13:09:08 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [BUG] 2.6.28-git LOCKDEP: Possible recursive rq->lock
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: svaidy@linux.vnet.ibm.com
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>
In-Reply-To: <20090104174450.GB4301@dirshya.in.ibm.com>
References: <20090104174450.GB4301@dirshya.in.ibm.com>
Content-Type: text/plain
Date: Sun, 04 Jan 2009 19:08:43 +0100
Message-Id: <1231092523.29980.4.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-01-04 at 23:14 +0530, Vaidyanathan Srinivasan wrote:
> Hi Ingo,
> 
> Kernbench runs on latest Linux git tree stalled with the following
> lockdep warning.
> 
> Lockdep warning and lockup on Jan 3 Linus git tree
> commit 7d3b56ba37a95f1f370f50258ed3954c304c524b
> 
> kernbench run with two threads stalled.  sched_mc was zero.
> x86_64 system with 8 logical CPUs in dual socket quad core
> configuration.
> 
> I will post more information as I debug this warning/bug.  

Its ca109491f612aab5c8152207631c0444f63da97f, I've some ideas on how to
fix this, just haven't gotten around to actually doing anything --
seeing how it was holidays and such..

