Return-Path: <linux-kernel-owner+w=401wt.eu-S933805AbXEPVhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933805AbXEPVhA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 17:37:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754860AbXEPVgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 17:36:53 -0400
Received: from adelie.ubuntu.com ([82.211.81.139]:38997 "EHLO
	adelie.ubuntu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754963AbXEPVgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 17:36:52 -0400
Subject: Re: [PATCH] Remove duplicate ID in ipaq driver
From: Ben Collins <ben.collins@ubuntu.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
       Ganesh Varadarajan <ganesh@veritas.com>,
       linux-usb-devel@lists.sourceforge.net
In-Reply-To: <ada1whgmqlx.fsf@cisco.com>
References: <1179348840.6510.16.camel@cunning>  <ada1whgmqlx.fsf@cisco.com>
Content-Type: text/plain
Organization: Canonical
Date: Wed, 16 May 2007 17:36:48 -0400
Message-Id: <1179351408.6510.24.camel@cunning>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-16 at 13:59 -0700, Roland Dreier wrote:
> >  	/* The first entry is a placeholder for the insmod-specified device */
>  > -	{ USB_DEVICE(0x049F, 0x0003) },
> 
> Is it obvious why this patch is correct?  Especially given the
> comment just before the line you delete, and the code
> 
> 	if (vendor) {
> 		ipaq_id_table[0].idVendor = vendor;
> 		ipaq_id_table[0].idProduct = product;
> 	}
> 
> in ipaq_init()?

My mistake, quick on the patching going through this dupe list.

Might I add that this is terrible use of the device table, though.
Clutters userspace, and adds processing to module-init-tools programs.

-- 
Ubuntu   : http://www.ubuntu.com/
Linux1394: http://wiki.linux1394.org/

