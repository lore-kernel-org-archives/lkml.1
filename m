Return-Path: <linux-kernel-owner+w=401wt.eu-S1754768AbYCYMGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768AbYCYMGK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 08:06:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753341AbYCYMF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 08:05:57 -0400
Received: from smtp-out02.alice-dsl.net ([88.44.60.12]:17017 "EHLO
	smtp-out02.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278AbYCYMF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 08:05:57 -0400
To: Paul Mackerras <paulus@samba.org>
Cc: David Miller <davem@davemloft.net>, clameter@sgi.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: larger default page sizes...
References: <Pine.LNX.4.64.0803211037140.18671@schroedinger.engr.sgi.com>
	<20080321.145712.198736315.davem@davemloft.net>
	<Pine.LNX.4.64.0803241121090.3002@schroedinger.engr.sgi.com>
	<20080324.133722.38645342.davem@davemloft.net>
	<18408.29107.709577.374424@cargo.ozlabs.ibm.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 25 Mar 2008 13:05:53 +0100
In-Reply-To: <18408.29107.709577.374424@cargo.ozlabs.ibm.com>
Message-ID: <87wsnrgg9q.fsf@basil.nowhere.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 25 Mar 2008 11:59:16.0522 (UTC) FILETIME=[A67468A0:01C88E6F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mackerras <paulus@samba.org> writes:
> 
> 4kB pages:	444.051s user + 34.406s system time
> 64kB pages:	419.963s user + 16.869s system time
> 
> That's nearly 10% faster with 64kB pages -- on a kernel compile.

Do you have some idea where the improvement mainly comes from?
Is it TLB misses or reduced in kernel overhead? Ok I assume both
play together but which part of the equation is more important?

-Andi
