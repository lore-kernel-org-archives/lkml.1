Return-Path: <linux-kernel-owner+w=401wt.eu-S1762726AbYASFXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762726AbYASFXy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 00:23:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751684AbYASFXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 00:23:47 -0500
Received: from one.firstfloor.org ([213.235.205.2]:54787 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbYASFXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 00:23:47 -0500
Date: Sat, 19 Jan 2008 06:27:09 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Announce] Development release 0.1 of the LatencyTOP tool
Message-ID: <20080119052709.GA28467@one.firstfloor.org>
References: <4790E3A6.7060807@linux.intel.com> <p73lk6m9ze7.fsf@bingen.suse.de> <47918792.2080201@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47918792.2080201@linux.intel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> yes indeed; I sort of use the same infrastructure inside the scheduler; the 
> biggest
> reason I felt I had to do something different was that I wanted to do per 
> process
> data collection, so that you can see for a specific process what was going 
> on.

Wouldn't it have been easier then to just extend the sleep profiler to
oprofile? oprofile already has pid filters and can do per process 
profiling.

On the other hand I'm not fully sure only doing per pid profiling
is that useful. After all often latencies come from asynchronous
threads (like kblockd). So a system level view is probably better
anyways. 

-Andi
