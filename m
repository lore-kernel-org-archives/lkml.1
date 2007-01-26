Return-Path: <linux-kernel-owner+w=401wt.eu-S1751432AbXAZUGM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751432AbXAZUGM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 15:06:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752133AbXAZUGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 15:06:12 -0500
Received: from smtp.osdl.org ([65.172.181.24]:52922 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751432AbXAZUGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 15:06:11 -0500
Date: Fri, 26 Jan 2007 12:05:54 -0800
From: Andrew Morton <akpm@osdl.org>
To: Adam Litke <agl@us.ibm.com>
Cc: linux-mm@kvack.org, david@gibson.dropbear.id.au,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Don't allow the stack to grow into hugetlb reserved
 regions
Message-Id: <20070126120554.671b1d6a.akpm@osdl.org>
In-Reply-To: <20070125214052.22841.33449.stgit@localhost.localdomain>
References: <20070125214052.22841.33449.stgit@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jan 2007 13:40:52 -0800
Adam Litke <agl@us.ibm.com> wrote:

> When expanding the stack, we don't currently check if the VMA will cross into
> an area of the address space that is reserved for hugetlb pages.  Subsequent
> faults on the expanded portion of such a VMA will confuse the low-level MMU
> code, resulting in an OOPS.  Check for this.

We prefer not to oops.  Is there any reason why this isn't a serious fix, needed
in 2.6.20 and 2.6.19?
