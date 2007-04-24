Return-Path: <linux-kernel-owner+w=401wt.eu-S1423122AbXDXVFL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423122AbXDXVFL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 17:05:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423116AbXDXVFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 17:05:11 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37874 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423122AbXDXVFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 17:05:09 -0400
Date: Tue, 24 Apr 2007 14:04:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, apw@shadowen.org,
       y-goto@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 1/2] Handle kernelcore= boot parameter in common code to
 avoid boot problem on IA64
Message-Id: <20070424140421.5c1e6457.akpm@linux-foundation.org>
In-Reply-To: <20070424180052.22005.61762.sendpatchset@skynet.skynet.ie>
References: <20070424180032.22005.82088.sendpatchset@skynet.skynet.ie>
	<20070424180052.22005.61762.sendpatchset@skynet.skynet.ie>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Apr 2007 19:00:52 +0100 (IST) Mel Gorman <mel@csn.ul.ie> wrote:

> 
> When "kernelcore" boot option is specified, kernel can't boot up on ia64
> because of an infinite loop.  In addition, the parsing code can be handled
> in an architecture-independent manner.
> 
> This patch patches uses common code to handle the kernelcore= parameter.
> It is only available to architectures that support arch-independent
> zone-sizing (i.e. define CONFIG_ARCH_POPULATES_NODE_MAP). Other architectures
> will ignore the boot parameter.
> 
> This effectively removes the following arch-specific patches;
> 
> ia64-specify-amount-of-kernel-memory-at-boot-time.patch
> ppc-and-powerpc-specify-amount-of-kernel-memory-at-boot-time.patch
> x86_64-specify-amount-of-kernel-memory-at-boot-time.patch
> x86-specify-amount-of-kernel-memory-at-boot-time.patch
> 

hm, OK.  That makes a bit of a mess of the patch series but we can live
with that.

> 
> Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
> Acked-by: Mel Gorman <mel@csn.ul.ie>
> Acked-by: Andy Whitcroft <apw@shadowen.org>

Patch protocol: Yasunori Gogo wrote the patch, so there should have been a
From:him at the very top of the changelog.  And you were in the patch
delivery path so you should have used Signed-off-by: rather than Acked-by:.
I made those two changes.


