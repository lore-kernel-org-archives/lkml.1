Return-Path: <linux-kernel-owner+w=401wt.eu-S1756360AbXJOH0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756360AbXJOH0a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 03:26:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751869AbXJOH0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 03:26:23 -0400
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:34136 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751864AbXJOH0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 03:26:22 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=wQTb3fN7fVOTyXs8au+HJfgt9hUjkylRuVHnl2SVxQZXettwLB+RJNWq7qF/AfvVwGTiUsCrfa2z5xU5XAQVP+Q6SBum2acZM+s421rWYYCoYx9V1Z3M7r2yVq1657OTp2TDMZIsoW0UvkXmLzcevi5FT1anqLXw2UeqcL3G5uw=  ;
X-YMail-OSG: O63Oe_oVM1ni2HAohUOPcgen7tvdv.dEqYArzq0.XYOCaObz2VwVFqqHWEOq0kibWgnoc_VSaq.cr0XjHeag3.bTBtD0_LsUkHsdd2j6LDKVs_rCas8KzrWb6Z6z7w--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: "Alok kataria" <alokkataria1@gmail.com>
Subject: Re: ARCH_FREE_PTE_NR 5350 on x86_64
Date: Mon, 15 Oct 2007 22:36:24 +1000
User-Agent: KMail/1.9.5
Cc: "Andi Kleen" <ak@suse.de>, hugh@veritas.com, linux-kernel@vger.kernel.org
References: <35f686220710142354k66e1b9acwf65864b138ffd26@mail.gmail.com>
In-Reply-To: <35f686220710142354k66e1b9acwf65864b138ffd26@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710152236.24789.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 October 2007 16:54, Alok kataria wrote:
> Hi,
>
> Looking at the tlb_flush code path and its co-relation with
> ARCH_FREE_PTE_NR, on x86-64 architecture. I think we still don't use
> the ARCH_FREE_PTE_NR of 5350 as the caching value for the mmu_gathers
> structure, instead fallback to using 506 due to some typo errors in
> the code.
>
> Found this link in the archives.
>
> http://www.ussg.iu.edu/hypermail/linux/kernel/0509.1/1821.html
>
> I don't think anything has been done on this yet (looked at 2.6.23).
> Do let me know if its only a typo that needs a fix, or we are still
> waiting for some other other changes to come into effect.

ARCH_FREE_PTE_NR should probably just get ripped out completely at
this point. Something similar (but working) could be added back if
anybody actually had a workload where it helps to increase the mmu
batch size.
