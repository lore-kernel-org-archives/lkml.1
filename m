Return-Path: <linux-kernel-owner+w=401wt.eu-S1753208AbZE2VJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208AbZE2VJ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 17:09:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751406AbZE2VJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 17:09:20 -0400
Received: from claw.goop.org ([74.207.240.146]:35349 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811AbZE2VJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 17:09:19 -0400
Message-ID: <4A204EFC.501@goop.org>
Date: Fri, 29 May 2009 14:09:16 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ian Campbell <ian.campbell@citrix.com>
CC: linux-kernel@vger.kernel.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Olaf Kirch <okir@suse.de>, Greg KH <gregkh@suse.de>,
       Tony Luck <tony.luck@intel.com>,
       Becky Bruce <beckyb@kernel.crashing.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Kumar Gala <galak@kernel.crashing.org>, x86@kernel.org,
       linux-ia64@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 6/9] swiotlb: use dma_to_phys and phys_to_dma
References: <1243586643-5554-1-git-send-email-ian.campbell@citrix.com> <1243586643-5554-7-git-send-email-ian.campbell@citrix.com>
In-Reply-To: <1243586643-5554-7-git-send-email-ian.campbell@citrix.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Campbell wrote:
> static dma_addr_t swiotlb_virt_to_bus(struct device *hwdev,
>  				      volatile void *address)
>  {
> -	return swiotlb_phys_to_bus(hwdev, virt_to_phys(address));
> +	return phys_to_dma(hwdev, virt_to_phys(address));
>  }
>  
>  void * __weak swiotlb_bus_to_virt(struct device *hwdev, dma_addr_t address)
>   

Does this need to be weak too?

    J
