Return-Path: <linux-kernel-owner+w=401wt.eu-S1757806AbYG1Udu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757806AbYG1Udu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 16:33:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751752AbYG1Udm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 16:33:42 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:60783 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbYG1Udm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 16:33:42 -0400
Subject: Re: [RFC] [PATCH 0/5 V2] Huge page backed user-space stacks
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Eric Munson <ebmunson@us.ibm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       libhugetlbfs-devel@lists.sourceforge.net
In-Reply-To: <cover.1216928613.git.ebmunson@us.ibm.com>
References: <cover.1216928613.git.ebmunson@us.ibm.com>
Content-Type: text/plain
Date: Mon, 28 Jul 2008 13:33:24 -0700
Message-Id: <1217277204.23502.36.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-28 at 12:17 -0700, Eric Munson wrote:
> 
> This patch stack introduces a personality flag that indicates the
> kernel
> should setup the stack as a hugetlbfs-backed region. A userspace
> utility
> may set this flag then exec a process whose stack is to be backed by
> hugetlb pages.

I didn't see it mentioned here, but these stacks are fixed-size, right?
They can't actually grow and are fixed in size at exec() time, right?

-- Dave

