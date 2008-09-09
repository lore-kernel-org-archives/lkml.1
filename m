Return-Path: <linux-kernel-owner+w=401wt.eu-S1756196AbYIIRiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196AbYIIRiZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 13:38:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753736AbYIIRiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 13:38:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33450 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753585AbYIIRiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 13:38:16 -0400
Date: Tue, 9 Sep 2008 10:37:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: mmotm 2008-09-08-18-32 uploaded
Message-Id: <20080909103741.6e10ee87.akpm@linux-foundation.org>
In-Reply-To: <20080909192544.8c0763d2.kamezawa.hiroyu@jp.fujitsu.com>
References: <200809090135.m891ZHiW020337@imap1.linux-foundation.org>
	<20080909192544.8c0763d2.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Sep 2008 19:25:44 +0900 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Mon, 08 Sep 2008 18:35:16 -0700
> akpm@linux-foundation.org wrote:
> 
> > The mm-of-the-moment snapshot 2008-09-08-18-32 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > It contains the following patches against 2.6.27-rc5:
> > 
> 
> I'll dig if I have time. This is just a report.
> 
> I tries UnixBench4.1 on x86_64/2cpu/1socket machine. (memory cgroup is enabled)
> 
> Following is comparison with a mmtom based on rc4.
> ===
> [rc4mm1]
> Execl Throughput                           3004.4 lps   (29.6 secs, 3 samples)
> C Compiler Throughput                      1017.9 lpm   (60.0 secs, 3 samples)
> Shell Scripts (1 concurrent)               5726.3 lpm   (60.0 secs, 3 samples)
> Shell Scripts (8 concurrent)               1124.3 lpm   (60.0 secs, 3 samples)
> Shell Scripts (16 concurrent)               576.0 lpm   (60.0 secs, 3 samples)
> Dc: sqrt(2) to 99 decimal places         125446.5 lpm   (30.0 secs, 3 samples)
> 
> [rc5mm1]
> Execl Throughput                           3006.5 lps   (29.8 secs, 3 samples)
> C Compiler Throughput                      1006.7 lpm   (60.0 secs, 3 samples)
> Shell Scripts (1 concurrent)               4863.7 lpm   (60.0 secs, 3 samples)
> Shell Scripts (8 concurrent)                943.7 lpm   (60.0 secs, 3 samples)
> Shell Scripts (16 concurrent)               482.7 lpm   (60.0 secs, 3 samples)
> Dc: sqrt(2) to 99 decimal places         124804.9 lpm   (30.0 secs, 3 samples)
> ==
> 15% down in shell script test. Any idea ? (scheduler ?)

Dunno.  There is a largel number of debugging patches at the tail of
the series so they should be the first thing to eliminate.

