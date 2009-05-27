Return-Path: <linux-kernel-owner+w=401wt.eu-S1752433AbZE0U3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433AbZE0U3a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 16:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750916AbZE0U3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 16:29:21 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:2884 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756AbZE0U3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 16:29:20 -0400
X-IronPort-AV: E=Sophos;i="4.41,261,1241409600"; 
   d="scan'208";a="52803654"
Subject: Re: [PATCH V2 2/3] powerpc: Add support for swiotlb on 32-bit
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Becky Bruce <beckyb@kernel.crashing.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <0628DF07-E085-4CC8-ADFC-1B0798343159@kernel.crashing.org>
References: <1242340949-16369-1-git-send-email-beckyb@kernel.crashing.org>
	 <1242340949-16369-2-git-send-email-beckyb@kernel.crashing.org>
	 <20090519142656T.fujita.tomonori@lab.ntt.co.jp>
	 <19E48A70-3332-423C-ACAD-390F940EE81C@kernel.crashing.org>
	 <4A1592CF.8000208@goop.org>
	 <E6DAA792-9923-4B76-9759-6955AABE3EAB@kernel.crashing.org>
	 <1242990702.22654.253.camel@zakaz.uk.xensource.com>
	 <0628DF07-E085-4CC8-ADFC-1B0798343159@kernel.crashing.org>
Content-Type: text/plain
Organization: Citrix Systems, Inc.
Date: Wed, 27 May 2009 21:29:19 +0100
Message-ID: <1243456159.4399.42.camel@localhost.localdomain>
MIME-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-27 at 15:05 -0400, Becky Bruce wrote:
> On May 22, 2009, at 6:11 AM, Ian Campbell wrote:
> >
> >
> > BTW do you need swiotlb_bus_to_virt to be __weak or is the fact that  
> > it
> > is implemented in terms of swiotlb_bus_to_phys sufficient?
> 
> The default one in swiotlb calls phys_to_virt on the result of  
> swiotlb_bus_to_phys, which only works on lowmem.

Perhaps we can simply enhance the default one to handle highmem instead
of making it arch specific?

Ian.


