Return-Path: <linux-kernel-owner+w=401wt.eu-S1753964AbYAXFVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964AbYAXFVQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 00:21:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751816AbYAXFVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 00:21:06 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:55653 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbYAXFVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 00:21:05 -0500
Date: Thu, 24 Jan 2008 14:20:05 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: rossb@google.com (Ross Biro), rossb@google.com
Subject: Re: [RFC][PATCH 1/2]: MM: Make Paget Tables Relocatable--Conditional  TLB Flush
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20080123161340.A1AAEDCA00@localhost>
References: <20080123161340.A1AAEDCA00@localhost>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20080124140913.5FFE.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.27 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello.

This is a nitpick, but all of archtectures code except generic use
MMF_NNED_FLUSH at clear_bit()...
     ^
Please fix misspell.

Bye.

> 
> diff -uprwNbB -X 2.6.23/Documentation/dontdiff 2.6.23/arch/alpha/kernel/smp.c 2.6.23a/arch/alpha/kernel/smp.c
> --- 2.6.23/arch/alpha/kernel/smp.c	2007-10-09 13:31:38.000000000 -0700
> +++ 2.6.23a/arch/alpha/kernel/smp.c	2007-10-29 13:50:06.000000000 -0700
> @@ -850,6 +850,8 @@ flush_tlb_mm(struct mm_struct *mm)
>  {
>  	preempt_disable();
>  
> +	clear_bit(MMF_NNED_FLUSH, mm->flags);
> +
>  	if (mm == current->active_mm) {
>  		flush_tlb_current(mm);
>  		if (atomic_read(&mm->mm_users) <= 1) {


-- 
Yasunori Goto 


