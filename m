Return-Path: <linux-kernel-owner+w=401wt.eu-S1759292AbYGFSeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759292AbYGFSeS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 14:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755698AbYGFSeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 14:34:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54431 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753016AbYGFSeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 14:34:05 -0400
Date: Sun, 6 Jul 2008 11:33:50 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [Bug #10872] x86_64 boot hang when CONFIG_NUMA=n
In-Reply-To: <20080706111750.a6d77e81.randy.dunlap@oracle.com>
Message-ID: <alpine.LFD.1.10.0807061133230.3016@woody.linux-foundation.org>
References: <Vu1KV8Wj_GP.A.qW.DzLcIB@albercik> <uBi7uNfg81L.A.XLC.s0LcIB@albercik> <20080706111750.a6d77e81.randy.dunlap@oracle.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 6 Jul 2008, Randy Dunlap wrote:
> 
> This still happens with 2.6.26-rc9.  Using CONFIG_NUMA=y boots OK.

Ok, then it wasn't the nr_zones thing.

Since it seems to be repeatable for you, can you bisect it?

		Linus
