Return-Path: <linux-kernel-owner+w=401wt.eu-S1755193AbYBDEc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193AbYBDEc5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 23:32:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751443AbYBDEcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 23:32:50 -0500
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:54797 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903AbYBDEct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 23:32:49 -0500
Message-ID: <47A6951E.3000600@linux.vnet.ibm.com>
Date: Mon, 04 Feb 2008 10:01:26 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, apw@shadowen.org
Subject: Re: 2.6.24-mm1 Build Faliure on pgtable_32.c
References: <20080203171634.58ab668b.akpm@linux-foundation.org> <20080204035543.GA8186@linux.vnet.ibm.com>
In-Reply-To: <20080204035543.GA8186@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kamalesh Babulal wrote:
> Hi Andrew,
> 
> The 2.6.24-mm1 kernel build fails with 
> 
> arch/x86/mm/pgtable_32.c: In function `pgd_mop_up_pmds':
> arch/x86/mm/pgtable_32.c:302: warning: passing arg 1 of `pmd_free' from incompatible pointer type
> arch/x86/mm/pgtable_32.c:302: error: too few arguments to function `pmd_free'
> 
> I have tested the patch for the build failure only.
> 
> Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

Looks good to me, it seems like a conflict between origin.patch and
add-mm-argument-to-pte-pmd-pud-pgd_free.patch

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
