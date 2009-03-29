Return-Path: <linux-kernel-owner+w=401wt.eu-S1756689AbZC2OXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689AbZC2OXy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 10:23:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754864AbZC2OXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 10:23:44 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:53328 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118AbZC2OXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 10:23:43 -0400
Date: Sun, 29 Mar 2009 16:23:36 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: virtualization@lists.linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       akpm@osdl.org, nickpiggin@yahoo.com.au, frankeh@watson.ibm.com,
       riel@redhat.com, hugh@veritas.com
Subject: Re: [patch 0/6] Guest page hinting version 7.
Message-ID: <20090329162336.7c0700e9@skybase>
In-Reply-To: <200903281705.29798.rusty@rustcorp.com.au>
References: <20090327150905.819861420@de.ibm.com>
	<200903281705.29798.rusty@rustcorp.com.au>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Mar 2009 17:05:28 +1030
Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Saturday 28 March 2009 01:39:05 Martin Schwidefsky wrote:
> > Greetings,
> > the circus is back in town -- another version of the guest page hinting
> > patches. The patches differ from version 6 only in the kernel version,
> > they apply against 2.6.29. My short sniff test showed that the code
> > is still working as expected.
> > 
> > To recap (you can skip this if you read the boiler plate of the last
> > version of the patches):
> > The main benefit for guest page hinting vs. the ballooner is that there
> > is no need for a monitor that keeps track of the memory usage of all the
> > guests, a complex algorithm that calculates the working set sizes and for
> > the calls into the guest kernel to control the size of the balloons.
> 
> I thought you weren't convinced of the concrete benefits over ballooning,
> or am I misremembering?

The performance test I have seen so far show that the benefits of
ballooning vs. guest page hinting are about the same. I am still
convinced that the guest page hinting is the way to go because you do
not need an external monitor. Calculating the working set size for a
guest is a challenge. With guest page hinting there is no need for a
working set size calculation.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

