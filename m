Return-Path: <linux-kernel-owner+w=401wt.eu-S1760249AbZAGSvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760249AbZAGSvu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 13:51:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754287AbZAGSvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 13:51:41 -0500
Received: from mga06.intel.com ([134.134.136.21]:50776 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751865AbZAGSvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 13:51:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,227,1231142400"; 
   d="scan'208";a="376474950"
From: Inaky Perez-Gonzalez <inaky@linux.intel.com>
Organization: Intel Corporation
To: wimax@linuxwimax.org
Subject: Re: linux-next: Tree for January 7 (wimax: more)
Date: Wed, 7 Jan 2009 10:51:22 -0800
User-Agent: KMail/1.9.9
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-wimax@intel.com
References: <20090107170646.8d44292b.sfr@canb.auug.org.au> <4964EDE6.5090902@oracle.com>
In-Reply-To: <4964EDE6.5090902@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901071051.23010.inaky@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 January 2009, Randy Dunlap wrote:
> Stephen Rothwell wrote:
> > Hi all,
> >
> > The powerpc ppc44x_defconfig builds again.
> >
> > Changes since 20090106:
>
> drivers/net/wimax/i2400m/usb.c:403: error: 'struct usb_device' has no
> member named 'autosuspend_delay' drivers/net/wimax/i2400m/usb.c:404: error:
> 'struct usb_device' has no member named 'autosuspend_disabled'
> drivers/net/wimax/i2400m/usb.c:506: error: 'struct usb_device' has no
> member named 'auto_pm'

Fix on the way -- need #ifdef CONFIG_PMs in a few parts.

-- 
Inaky
