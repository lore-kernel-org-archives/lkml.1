Return-Path: <linux-kernel-owner+w=401wt.eu-S1761764AbYDCIlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761764AbYDCIlZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 04:41:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755226AbYDCIlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 04:41:17 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:10146 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbYDCIlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 04:41:16 -0400
To: Nick Piggin <npiggin@suse.de>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [rfc] SLQB: YASA
From: Andi Kleen <andi@firstfloor.org>
References: <84144f020804030045p44456894lfc006dcdeab6f67c@mail.gmail.com>
	<20080403075725.GA7514@wotan.suse.de>
	<20080403171626.0283.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20080403082650.GA20132@wotan.suse.de>
Date: Thu, 03 Apr 2008 10:41:13 +0200
In-Reply-To: <20080403082650.GA20132@wotan.suse.de> (Nick Piggin's message of "Thu, 3 Apr 2008 10:26:51 +0200")
Message-ID: <87r6dns53q.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 03 Apr 2008 08:34:32.0418 (UTC) FILETIME=[8A46A420:01C89565]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <npiggin@suse.de> writes:
>
> Nothing really interesting, unfortunately. I have run some tests on
> various microbenchmarks like tbench and things like that. But I
> don't have many good ideas for more meaningful tests where slab
> allocation performance is critial. Any suggestions? :)

Some networking workloads hit slab pretty aggressive (two 
allocations per packet) 

Just be careful with standard loopback, it has a contended lock
elsewhere

-Andi
