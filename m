Return-Path: <linux-kernel-owner+w=401wt.eu-S1757517AbZBBRfE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757517AbZBBRfE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 12:35:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752637AbZBBRex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 12:34:53 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:31096 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552AbZBBRex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 12:34:53 -0500
Date: Mon, 2 Feb 2009 09:32:26 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: unknown symbols in 2.6.29-rc3
Message-Id: <20090202093226.fa883b13.randy.dunlap@oracle.com>
In-Reply-To: <200901291023.32497.oliver@neukum.org>
References: <200901291023.32497.oliver@neukum.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt707.oracle.com [141.146.40.85]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010209.49872E2E.0112:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Jan 2009 10:23:31 +0100 Oliver Neukum wrote:

> Hi,
> 
> "make modules_install" reports unknown symbols:
> 
> WARNING: /lib/modules/2.6.29-rc3-9-default/kernel/fs/udf/udf.ko needs unknown symbol crc_itu_t
> WARNING: /lib/modules/2.6.29-rc3-9-default/kernel/drivers/gpu/drm/sis/sis.ko needs unknown symbol sis_malloc
> WARNING: /lib/modules/2.6.29-rc3-9-default/kernel/drivers/gpu/drm/sis/sis.ko needs unknown symbol sis_free
> WARNING: /lib/modules/2.6.29-rc3-9-default/kernel/drivers/net/irda/mcs7780.ko needs unknown symbol crc_ccitt
> WARNING: /lib/modules/2.6.29-rc3-9-default/kernel/drivers/net/irda/vlsi_ir.ko needs unknown symbol crc_ccitt
> WARNING: /lib/modules/2.6.29-rc3-9-default/kernel/drivers/net/via-velocity.ko needs unknown symbol crc_ccitt
> WARNING: /lib/modules/2.6.29-rc3-9-default/kernel/drivers/net/ppp_async.ko needs unknown symbol crc_ccitt_table
> WARNING: /lib/modules/2.6.29-rc3-9-default/kernel/drivers/net/hamradio/mkiss.ko needs unknown symbol crc16
> WARNING: /lib/modules/2.6.29-rc3-9-default/kernel/drivers/net/hamradio/hdlcdrv.ko needs unknown symbol crc_ccitt
> WARNING: /lib/modules/2.6.29-rc3-9-default/kernel/net/sctp/sctp.ko needs unknown symbol crc32c
> WARNING: /lib/modules/2.6.29-rc3-9-default/kernel/net/irda/irda.ko needs unknown symbol crc_ccitt_table
> 
> The configuration producing this is attached.

Hi Oliver,

I don't see this error with your config file.
Maybe you need to do a "make distclean" and rebuild everything?


---
~Randy
