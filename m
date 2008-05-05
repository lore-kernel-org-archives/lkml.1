Return-Path: <linux-kernel-owner+w=401wt.eu-S1760035AbYEERIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760035AbYEERIn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 13:08:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755559AbYEERIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 13:08:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55738 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756696AbYEERIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 13:08:34 -0400
Date: Mon, 5 May 2008 10:07:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: manfred@colorfullife.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, efault@gmx.de
Subject: Re: [PATCH 00/10] Scalability requirements for sysv ipc - v2
Message-Id: <20080505100743.cdc571d8.akpm@linux-foundation.org>
In-Reply-To: <481F3B62.9020407@bull.net>
References: <20080429143304.741001000@bull.net>
	<20080429115424.41b82fcb.akpm@linux-foundation.org>
	<481F3B62.9020407@bull.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 May 2008 18:52:50 +0200 Nadia Derbey <Nadia.Derbey@bull.net> wrote:

>                  2.6.25-mm1 (ref)   2.6.25-mm1(patched)
> 
> Total (1 cpu):   876000             985496
> Total (2 cpus): 1549592            1740591
> Total (3 cpus): 1694370            2327468
> Total (4 cpus):  404553            2465787
> Total (5 cpus):  391283            3215676
> Total (6 cpus):  263249            3849121
> Total (7 cpus):  191742            4209866
> Total (8 cpus):  141722            4255585
> 

Looks encouraging.  A comparison with 2.6.22 (or whichever kernel it was
before we broke it) would be interesting too, please.

> 
> Full output files attached.
>
> Will send the rest tomorrow.

Nobody reads the raw data, sorry.  And it is inefficient to have everyone
independently pore over the raw data extracting the (same) actual
information.

Please condense the result of your performance testing into a
preferably-less-than-one-page summary and include (and maintain) that within
the patch changelog.

