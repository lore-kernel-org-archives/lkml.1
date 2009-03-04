Return-Path: <linux-kernel-owner+w=401wt.eu-S1756091AbZCDRec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091AbZCDRec (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 12:34:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755043AbZCDReW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 12:34:22 -0500
Received: from rv-out-0506.google.com ([209.85.198.228]:43933 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754696AbZCDReW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 12:34:22 -0500
Message-ID: <49AEBB8C.2000405@codemonkey.ws>
Date: Wed, 04 Mar 2009 11:34:04 -0600
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Nick Piggin <nickpiggin@yahoo.com.au>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] xen: core dom0 support
References: <1235786365-17744-1-git-send-email-jeremy@goop.org>	<200902282309.07576.nickpiggin@yahoo.com.au>	<49AB19E1.4050604@goop.org>	<200903021737.24903.nickpiggin@yahoo.com.au> <49AB9336.7010103@goop.org>
In-Reply-To: <49AB9336.7010103@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Nick Piggin wrote:

> It really depends on the workload.  There's three cases to consider: 
> software shadow pagetables, hardware nested pagetables, and Xen direct 
> pagetables.  Even now, Xen's (highly optimised) shadow pagetable code 
> generally out-performs modern nested pagetables, at least when running 
> Windows (for which that code was most heavily tuned).

Can you point to benchmarks?  I have a hard time believing this.

How can shadow paging beat nested paging assuming the presence of large 
pages?

Regards,

Anthony Liguori
