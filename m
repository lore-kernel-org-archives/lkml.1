Return-Path: <linux-kernel-owner+w=401wt.eu-S1757946AbXK0J6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757946AbXK0J6A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 04:58:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753671AbXK0J5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 04:57:53 -0500
Received: from ozlabs.org ([203.10.76.45]:38860 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753480AbXK0J5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 04:57:52 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18251.59930.30260.145217@cargo.ozlabs.ibm.com>
Date: Tue, 27 Nov 2007 20:57:46 +1100
From: Paul Mackerras <paulus@samba.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>
Subject: Re: time accounting problem (powerpc only?)
In-Reply-To: <1196094193.4149.287.camel@johannes.berg>
References: <1195814816.4149.94.camel@johannes.berg>
	<1196094193.4149.287.camel@johannes.berg>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Berg writes:

> Contrary to what I claimed later in the thread, my 64-bit powerpc box
> (quad-core G5) doesn't suffer from this problem.
> 
> Does anybody have any idea? I don't even know how to debug it further.

I see it on my G4 powerbook.  However, a compute-bound task runs just
as fast (i.e. completes in the same elapsed time) as on older kernels,
so it does look like it is just an accounting problem.  If the CPU was
really spending more than half its time servicing hardware interrupts,
the task should take more than twice as long to complete.

Paul.

