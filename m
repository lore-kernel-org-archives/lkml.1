Return-Path: <linux-kernel-owner+w=401wt.eu-S1754925AbYBLU03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925AbYBLU03 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 15:26:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763636AbYBLU0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 15:26:13 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:62486 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763588AbYBLU0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 15:26:11 -0500
Message-ID: <47B1FFB4.7010904@oracle.com>
Date: Tue, 12 Feb 2008 12:21:08 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: mgross@linux.intel.com
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH]intel-iommu batched iotlb flushes
References: <20080211224105.GB24412@linux.intel.com> <20080211152716.65f5a753.randy.dunlap@oracle.com> <20080212160553.GD27490@linux.intel.com> <47B1CA9F.80004@oracle.com> <20080212195532.GA29132@linux.intel.com>
In-Reply-To: <20080212195532.GA29132@linux.intel.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Index: linux-2.6.24-mm1/Documentation/kernel-parameters.txt
> ===================================================================
> --- linux-2.6.24-mm1.orig/Documentation/kernel-parameters.txt	2008-02-12 07:12:06.000000000 -0800
> +++ linux-2.6.24-mm1/Documentation/kernel-parameters.txt	2008-02-12 11:36:07.000000000 -0800
> @@ -822,6 +822,10 @@
>  			than 32 bit addressing. The default is to look
>  			for translation below 32 bit and if not available
>  			then look in the higher range.
> +		strict [Default Off]
> +			With this option on every umap_signle operation will

	umap_signle ???  (again)

> +			result in a hardware IOTLB flush operation as opposed
> +			to batching them for performance.
>  
>  	io_delay=	[X86-32,X86-64] I/O delay method
>  		0x80


-- 
~Randy
