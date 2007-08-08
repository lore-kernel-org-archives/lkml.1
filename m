Return-Path: <linux-kernel-owner+w=401wt.eu-S936934AbXHHQe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936934AbXHHQe6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 12:34:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933695AbXHHQeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 12:34:44 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:50791 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765061AbXHHQem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 12:34:42 -0400
Subject: Re: [RFC][PATCH 1/5] pagemap: remove file header
From: Dave Hansen <haveblue@us.ibm.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       serue@us.ibm.com
In-Reply-To: <20070808023100.222c4d15@the-village.bc.nu>
References: <20070807223300.9228E0E0@kernel>
	 <20070808011620.GF30556@waste.org>
	 <20070808023100.222c4d15@the-village.bc.nu>
Content-Type: text/plain
Date: Wed, 08 Aug 2007 09:34:39 -0700
Message-Id: <1186590879.22283.99.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-08 at 02:31 +0100, Alan Cox wrote:
> The information needed to parse /proc/pid/pagemap can be stuck
> in /proc/pid/somewherelese. If we ever get page size variations and the
> like then /proc/pid/ is going to end up with that information anyway for
> ps and friends to use.

We do at least have some of this with hugetlbfs.  In fact, the current
pagemap code bugs out when it hits a huge page area:

/home/dave/work/linux/2.6/22/lxc/mm/memory.c:117: bad pgd 1d0000e7.

I'll look at fixing that.

-- Dave

