Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238Ab0CASDQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 13:03:16 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:48962 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200Ab0CASDM (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 1 Mar 2010 13:03:12 -0500
Date: Mon, 1 Mar 2010 12:38:58 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Sheng Yang <sheng@linux.intel.com>
Cc: Keir Fraser <keir.fraser@eu.citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>,
       Ian Campbell <Ian.Campbell@citrix.com>,
       Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
       xen-devel <xen-devel@lists.xensource.com>, linux-kernel@vger.kernel.org
Subject: Re: [LKML] [PATCH 7/7] xen: Enable grant table and xenbus for PV
	extension of HVM
Message-ID: <20100301173858.GJ7881@phenom.dumpdata.com>
References: <1267436315-24486-1-git-send-email-sheng@linux.intel.com> <1267436315-24486-8-git-send-email-sheng@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267436315-24486-8-git-send-email-sheng@linux.intel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4B8C0151.0219:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +/* The region reserved by QEmu for Xen platform device */
> +#define GNTTAB_START	    0xf2000000ul
> +#define GNTTAB_SIZE	    0x20000ul

I thought that in the earlier review you said:

"> > +#define GNTTAB_START           0xfbfe0000ul
> > +#define GNTTAB_SIZE            0x20000ul 
> 
> Is it possible that there would be a PCI device that would be
> passed in the guest that would conflict with the above mentioned
> E820 region?
>
I would change them to a dedicated PCI MMIO address in the next version.
Thanks.

"
?
