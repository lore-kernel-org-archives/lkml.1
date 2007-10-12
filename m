Return-Path: <linux-kernel-owner+w=401wt.eu-S1759963AbXJLVsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759963AbXJLVsv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 17:48:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758442AbXJLVop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 17:44:45 -0400
Received: from 224.sub-75-208-255.myvzw.com ([75.208.255.224]:42272 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760489AbXJLVom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 17:44:42 -0400
Message-Id: <20071012211132.198718000@goop.org>
User-Agent: quilt/0.46-1
Date: Fri, 12 Oct 2007 14:11:32 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Keir Fraser <keir@xensource.com>
Subject: [PATCH 00/10] REVIEW: Xen patches for 2.6.24
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is my current set of updates to Xen for 2.6.24.  This is largely
a bugfix set, and a couple of them are also relevent to 2.6.23.

These are in the pre-x86 merge form; I'll update them once the merge
goes into git.

Quick overview:
 - remove some dead code in arch/i386/mm/init.c
 - clean up some duplicate includes
 - when sending an IPI, yield the vcpu if the destination doesn't have
   a real cpu to run on
 - fix a bug where a lazy cr3 reload can prevent a pagetable from being
   unpinned
 - deal with split pte locks properly
 - fix an old structure used for the register_vcpu_info hypercall
 - add some multicall debugging help
 - workaround for a bad XFS/Xen interaction

Thanks,
	J

-- 

