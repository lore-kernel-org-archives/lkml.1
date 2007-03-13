Return-Path: <linux-kernel-owner+w=401wt.eu-S965678AbXCMJpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965678AbXCMJpA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 05:45:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965691AbXCMJo7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 05:44:59 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:54313
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965678AbXCMJo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 05:44:58 -0400
Message-Id: <45F680D9.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.1 
Date: Tue, 13 Mar 2007 09:45:45 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <linux-kernel@vger.kernel.org>
Subject: __HAVE_ARCH_PTEP_TEST_AND_CLEAR_{DIRTY,YOUNG} on i386
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Isn't defining these on i386 of at most historical value. The only consumer is
include/asm-generic/pgtable.h (ptep_clear_flush_{dirty,young}), and those are
already suppressed by __HAVE_ARCH_PTEP_CLEAR_{DIRTY,YOUNG}_FLUSH
being defined in include/asm-i386/pgtable.h. Or is there a particular need to
detect if other uses appear (in which case the comment accompanying their
definitions is pretty misleading)?

Thanks, Jan
