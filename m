Return-Path: <linux-kernel-owner+w=401wt.eu-S1757365AbZGPDle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757365AbZGPDle (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 23:41:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757334AbZGPDld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 23:41:33 -0400
Received: from gate.crashing.org ([63.228.1.57]:50337 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757331AbZGPDlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 23:41:32 -0400
Subject: Re: [PATCH 04/15] swiotlb: remove unnecessary swiotlb_bus_to_virt
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Becky Bruce <beckyb@kernel.crashing.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
       linuxppc-dev@ozlabs.org, tony.luck@intel.com, x86@kernel.org
In-Reply-To: <5E909C02-3FA2-4BEB-8C73-F4E4A5A404BF@kernel.crashing.org>
References: <1247187904-31999-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	 <1247187904-31999-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	 <5E909C02-3FA2-4BEB-8C73-F4E4A5A404BF@kernel.crashing.org>
Content-Type: text/plain
Date: Thu, 16 Jul 2009 13:40:18 +1000
Message-Id: <1247715618.27937.36.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-13 at 21:17 -0500, Becky Bruce wrote:
> 
> phys_to_virt (also, virt_to_phys) is invalid for highmem addresses on  
> ppc. 

I would be surprised if x86 was any different here. Most of our highmem
implementation comes straight from x86 :-)

Cheers,
Ben.


