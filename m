Return-Path: <linux-kernel-owner+w=401wt.eu-S1754489AbZJESMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489AbZJESMs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 14:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754350AbZJESMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 14:12:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47456 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754337AbZJESMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 14:12:47 -0400
Date: Mon, 5 Oct 2009 11:12:06 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jeff Chua <jeff.chua.linux@gmail.com>
cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: 2.6.32-rc3: low mem - only 378MB on x86_32 with 64GB. Why?
In-Reply-To: <Pine.LNX.4.64.0910052334480.17655@boston.corp.fedex.com>
Message-ID: <alpine.LFD.2.01.0910051110200.3432@localhost.localdomain>
References: <Pine.LNX.4.64.0910052334480.17655@boston.corp.fedex.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 5 Oct 2009, Jeff Chua wrote:
> 
> I've 3 systems with 4GB, 16GB and 64GB all running 32bit with these set:

Don't.

4GB is useable. 8GB is borderline. 16GB+ and nobody will care.

> # with 64GB
>              total       used       free     shared    buffers     cached
> Mem:         63995        524      63470          0          4        365
> Low:           378         32        345

All your low memory is used for the 'struct page' arrays that describe 
everything else.

> Anything I should do?

Use a 64-bit CPU and kernel or limit your memory to 8GB or so. No ifs, 
buts and maybe's.

			Linus
