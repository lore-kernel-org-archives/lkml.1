Return-Path: <linux-kernel-owner+w=401wt.eu-S1760925AbXGaUOI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760925AbXGaUOI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 16:14:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756016AbXGaUNx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 16:13:53 -0400
Received: from mga05.intel.com ([192.55.52.89]:36320 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754810AbXGaUNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 16:13:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,204,1183359600"; 
   d="scan'208";a="274916581"
From: Inaky Perez-Gonzalez <inaky@linux.intel.com>
Organization: Intel Corporation
To: Adrian Bunk <bunk@stusta.de>
Subject: Re: [-mm patch] USB: make dev_attr_authorized_default static
Date: Tue, 31 Jul 2007 12:13:46 -0700
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net
References: <20070725040304.111550f4.akpm@linux-foundation.org> <20070729145858.GC16817@stusta.de>
In-Reply-To: <20070729145858.GC16817@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707311213.46915.inaky@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 29 July 2007 07:58, Adrian Bunk wrote:
> -DEVICE_ATTR(authorized_default, 0644,
> -	    usb_host_authorized_default_show,
> -	    usb_host_authorized_default_store);
> +static DEVICE_ATTR(authorized_default, 0644,
> > +		   usb_host_authorized_default_show, 

Ack, patchset updated -- thanks!
