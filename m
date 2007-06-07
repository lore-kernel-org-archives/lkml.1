Return-Path: <linux-kernel-owner+w=401wt.eu-S965645AbXFGDUN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965645AbXFGDUN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 23:20:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755175AbXFGDUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 23:20:00 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:58757 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755144AbXFGDT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 23:19:59 -0400
Date: Wed, 6 Jun 2007 23:11:03 -0400
From: Jeff Dike <jdike@addtoit.com>
To: "Li, Xin B" <xin.b.li@intel.com>
Cc: avi@qumranet.com, kvm-devel@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [kvm-devel] [PATCH] KVM - Fix rmode_tss_base declaration
Message-ID: <20070607031103.GA12462@c2.user-mode-linux.org>
References: <20070606191925.GA8989@c2.user-mode-linux.org> <B30DA1341B0CFA4893EF8A36B40B5C5D013A32CB@pdsmsx411.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B30DA1341B0CFA4893EF8A36B40B5C5D013A32CB@pdsmsx411.ccr.corp.intel.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2007 at 10:13:42AM +0800, Li, Xin B wrote:
> >-static int rmode_tss_base(struct kvm* kvm)
> >+static unsigned long rmode_tss_base(struct kvm* kvm)
> 
> Should use gpa_t instead.

Right you are, I didn't notice that type.

Will fix.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
