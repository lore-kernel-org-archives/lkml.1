Return-Path: <linux-kernel-owner+w=401wt.eu-S1423437AbXBPJMM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423437AbXBPJMM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 04:12:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423438AbXBPJML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 04:12:11 -0500
Received: from colin.muc.de ([193.149.48.1]:2726 "EHLO mail.muc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423437AbXBPJMK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 04:12:10 -0500
Date: 16 Feb 2007 10:12:07 +0100
Date: Fri, 16 Feb 2007 10:12:07 +0100
From: Andi Kleen <ak@muc.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>
Subject: Re: [patch 04/21] Xen-paravirt: ===================================================================
Message-ID: <20070216091207.GA28196@muc.de>
References: <20070216022449.739760547@goop.org> <20070216022530.755967483@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070216022530.755967483@goop.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Subject? description?


On Thu, Feb 15, 2007 at 06:24:53PM -0800, Jeremy Fitzhardinge wrote:
> -static void vmi_set_pte_present(struct mm_struct *mm, unsigned long addr, pte_t *ptep, pte_t pte)
> +static void vmi_set_pte_present(struct mm_struct *mm, u32 addr, pte_t *ptep, pte_t pte)

And what good is that change anyways? unsigned long is the usual style
for addresses.

-Andi
