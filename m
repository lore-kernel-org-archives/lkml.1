Return-Path: <linux-kernel-owner+w=401wt.eu-S1751560AbXH1FS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751560AbXH1FS4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 01:18:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750716AbXH1FSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 01:18:48 -0400
Received: from [212.12.190.144] ([212.12.190.144]:32860 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750711AbXH1FSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 01:18:47 -0400
From: Al Boldi <a1426z@gawab.com>
To: linux-kernel@vger.kernel.org
Subject: Re: oom-killer with 27G free swap and overcommit_memory=2
Date: Tue, 28 Aug 2007 08:18:57 +0300
User-Agent: KMail/1.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708280818.57608.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Patrick J. LoPresti wrote:
> My system is a SunFire x4100 (x86_64) with 16G of RAM and 32G of swap
> in a single partition.  I have an application which consumes a lot of
> memory, and after a few hours the oom-killer kills it.
> 
> This would not be surprising, except a) the machine still has 27G of
> free swap at the time; and b) it happens even when I set
> vm.overcommit_memory=2 (with overcommit_ratio=50).  It is
> time-consuming to reproduce, but consistent.
:
:
> 2) Is there any sysctl setting that might "avoid" this problem?  Or a
> way to change my application to avoid it?

Try setting the overcommit_ratio=0.


Thanks!

--
Al

