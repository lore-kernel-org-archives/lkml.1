Return-Path: <linux-kernel-owner+w=401wt.eu-S1754829AbZC1Gfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829AbZC1Gfp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 02:35:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751830AbZC1Gff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 02:35:35 -0400
Received: from ozlabs.org ([203.10.76.45]:57974 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751666AbZC1Gff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 02:35:35 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: virtualization@lists.linux-foundation.org
Subject: Re: [patch 0/6] Guest page hinting version 7.
Date: Sat, 28 Mar 2009 17:05:28 +1030
User-Agent: KMail/1.11.1 (Linux/2.6.27-11-generic; KDE/4.2.1; i686; ; )
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       akpm@osdl.org, nickpiggin@yahoo.com.au, frankeh@watson.ibm.com,
       riel@redhat.com, hugh@veritas.com
References: <20090327150905.819861420@de.ibm.com>
In-Reply-To: <20090327150905.819861420@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903281705.29798.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 28 March 2009 01:39:05 Martin Schwidefsky wrote:
> Greetings,
> the circus is back in town -- another version of the guest page hinting
> patches. The patches differ from version 6 only in the kernel version,
> they apply against 2.6.29. My short sniff test showed that the code
> is still working as expected.
> 
> To recap (you can skip this if you read the boiler plate of the last
> version of the patches):
> The main benefit for guest page hinting vs. the ballooner is that there
> is no need for a monitor that keeps track of the memory usage of all the
> guests, a complex algorithm that calculates the working set sizes and for
> the calls into the guest kernel to control the size of the balloons.

I thought you weren't convinced of the concrete benefits over ballooning,
or am I misremembering?

Thanks,
Rusty.
