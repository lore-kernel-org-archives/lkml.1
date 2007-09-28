Return-Path: <linux-kernel-owner+w=401wt.eu-S1755520AbXI1SDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520AbXI1SDl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 14:03:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753467AbXI1SDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 14:03:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53243 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752322AbXI1SDe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 14:03:34 -0400
Date: Fri, 28 Sep 2007 14:03:22 -0400
From: Rik van Riel <riel@redhat.com>
To: "Sergey Popov" <faijeya@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: General slowness with using 64Gb HIGHMEM option on 32-bit
 kernel
Message-ID: <20070928140322.5fbbde5d@bree.surriel.com>
In-Reply-To: <dd4eba420709281057x69a9366cp8fc755782efea656@mail.gmail.com>
References: <dd4eba420709281015w50bd6b0fj21f72756a962a26b@mail.gmail.com>
	<46FD3DE1.9000807@redhat.com>
	<dd4eba420709281057x69a9366cp8fc755782efea656@mail.gmail.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Sep 2007 21:57:55 +0400
"Sergey Popov" <faijeya@gmail.com> wrote:

> Ok, I found a palliative.
> 
> Now I'm working with "mem=6770M" option, that gives me 6072MB RAM (of
> 6144 total).
> Interesting, that if you choose too much, like "mem=6800M", system
> behaviour is exactly the same as without any options.
> 
> Can it be that kernel incorrectly sets amount of memory to use so such
> a situation occurs?

Maybe the BIOS marks the top megabytes of memory as
uncacheable, which makes accesses ridiculously slow.

Cat /proc/mtrr to check.

-- 
"Debugging is twice as hard as writing the code in the first place.
Therefore, if you write the code as cleverly as possible, you are,
by definition, not smart enough to debug it." - Brian W. Kernighan
