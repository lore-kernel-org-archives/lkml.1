Return-Path: <linux-kernel-owner+w=401wt.eu-S1760446AbXFRHTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760446AbXFRHTq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 03:19:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758059AbXFRHTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 03:19:38 -0400
Received: from bay0-omc3-s30.bay0.hotmail.com ([65.54.246.230]:10014 "EHLO
	bay0-omc3-s30.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757323AbXFRHTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 03:19:37 -0400
X-Originating-IP: [65.93.40.159]
X-Originating-Email: [seanlkml@sympatico.ca]
Date: Mon, 18 Jun 2007 03:01:32 -0400
From: Sean <seanlkml@sympatico.ca>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Carlo Wood <carlo@alinoe.com>, Dave Jones <davej@redhat.com>,
       linux-kernel@vger.kernel.org, eric@anholt.net, zhenyu.z.wang@intel.com,
       y-goto@jp.fujitsu.com, torvalds@linux-foundation.org
Subject: Re: 2.6.22-rc5 regression
Message-Id: <20070618030132.26ca4eb4.seanlkml@sympatico.ca>
In-Reply-To: <20070618002548.GC27460@linux-sh.org>
References: <20070617182254.GA17595@alinoe.com>
	<20070617195805.GA6125@alinoe.com>
	<20070617214905.GA6207@alinoe.com>
	<20070617231858.GB27460@linux-sh.org>
	<20070618001049.GB1375@alinoe.com>
	<20070618002548.GC27460@linux-sh.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Jun 2007 07:19:37.0318 (UTC) FILETIME=[07315060:01C7B179]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jun 2007 09:25:48 +0900
Paul Mundt <lethal@linux-sh.org> wrote:

> $ git show d09c6b809432668371b5de9102f4f9aa6a7c79cc | patch -p1 -R
> ... build and test ...
> $ git show d09c6b809432668371b5de9102f4f9aa6a7c79cc | patch -p1
> ... back to original (or git checkout-index -f mm/page_alloc.c) ...

Please forgive my git fanboyism, but assuming you have no
uncommitted changes in your working tree, you could also:

$ git revert -n d09c6b809432
  ... build and test ...

$ git reset --hard
  ... back to original ...


cheers,
Sean
