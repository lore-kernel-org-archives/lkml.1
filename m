Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724Ab0BBRfM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 12:35:12 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:51245 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835Ab0BBRfJ (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 2 Feb 2010 12:35:09 -0500
Date: Tue, 2 Feb 2010 12:03:06 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Sheng Yang <sheng@linux.intel.com>
Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Keir Fraser <keir.fraser@eu.citrix.com>,
       xen-devel <xen-devel@lists.xensource.com>, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH 6/6] xen/hybrid: Enable grant table and
	xenbus
Message-ID: <20100202170306.GA32305@phenom.dumpdata.com>
References: <1265098747-10117-1-git-send-email-sheng@linux.intel.com> <1265098747-10117-7-git-send-email-sheng@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265098747-10117-7-git-send-email-sheng@linux.intel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4B686246.0022:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +#define GNTTAB_START	    0xfbfe0000ul
> +#define GNTTAB_SIZE	    0x20000ul

Is it possible that there would be a PCI device that would be 
passed in the guest that would conflict with the above mentioned
E820 region?
