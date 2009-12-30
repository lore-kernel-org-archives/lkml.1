Return-Path: <linux-kernel-owner+w=401wt.eu-S1751727AbZL3BIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751727AbZL3BIk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 20:08:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751455AbZL3BIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 20:08:39 -0500
Received: from outbound.icp-qv1-irony-out1.iinet.net.au ([203.59.1.106]:11303
	"EHLO outbound.icp-qv1-irony-out1.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751472AbZL3BIj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 20:08:39 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmEBAM82Okt8qNTn/2dsb2JhbAAI1H2EMQQ
X-IronPort-AV: E=Sophos;i="4.47,471,1257091200"; 
   d="scan'208";a="615689120"
Subject: Re: Question of resource_size() implementation
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Ben Nizette <bn@niasdigital.com>
In-Reply-To: <251FB18F-5D6A-4BBE-A69D-F6203E09058B@niasdigital.com>
Date: Wed, 30 Dec 2009 12:08:34 +1100
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <0CE3DF69-C498-44BA-8CEA-C9AA5DB4CF84@niasdigital.com>
References: <1262130234.28789.112.camel@gandalf> <1262131932.1888.202.camel@Joe-Laptop.home> <1262132171.28789.136.camel@gandalf> <251FB18F-5D6A-4BBE-A69D-F6203E09058B@niasdigital.com>
To: me@felipebalbi.com
X-Mailer: Apple Mail (2.1077)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 30/12/2009, at 12:04 PM, Ben Nizette wrote:
> 
> 
> So resource_size would return SZ_4K and ioremap would map the SZ_4K bytes starting at MEM_AREA1_BASE, i.e. MEM_AREA1_BASE to MEM_AREA1_BASE - 1 /inclusive/.  This is also correct.
> 

IOW it's a matter of convention.  Either we could define a single-byte range to be end=start and put the +1 in the resource_size or we could define a single-byte range to be end=start+1 and leave the +1 out of resource_size.  The in-kernel convention is the former

> 	--Ben.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

