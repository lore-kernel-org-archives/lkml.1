Return-Path: <linux-kernel-owner+w=401wt.eu-S1760625AbYBMSZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760625AbYBMSZa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 13:25:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751883AbYBMSZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 13:25:21 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:63137 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847AbYBMSZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 13:25:20 -0500
Message-ID: <47B335A6.3080806@oracle.com>
Date: Wed, 13 Feb 2008 10:23:34 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: mgross@linux.intel.com
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH]intel-iommu batched iotlb flushes
References: <20080211224105.GB24412@linux.intel.com> <20080211152716.65f5a753.randy.dunlap@oracle.com> <20080212160553.GD27490@linux.intel.com> <47B1CA9F.80004@oracle.com> <20080212195532.GA29132@linux.intel.com> <47B1FFB4.7010904@oracle.com> <20080213181029.GA1162@linux.intel.com>
In-Reply-To: <20080213181029.GA1162@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
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
> +			With this option on every umap_single operation will

so I'll ask one more time :(
Shouldn't this be "unmap_single" ?

> +			result in a hardware IOTLB flush operation as opposed
> +			to batching them for performance.
>  
>  	io_delay=	[X86-32,X86-64] I/O delay method
>  		0x80


-- 
~Randy
