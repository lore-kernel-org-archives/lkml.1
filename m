Return-Path: <linux-kernel-owner+w=401wt.eu-S934501AbXEPVAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934501AbXEPVAn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 17:00:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934233AbXEPVAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 17:00:14 -0400
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:63386 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933805AbXEPVAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 17:00:11 -0400
X-IronPort-AV: i="4.14,544,1170662400"; 
   d="scan'208"; a="486349636:sNHT43193270"
To: Ben Collins <ben.collins@ubuntu.com>
Cc: linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
       Ganesh Varadarajan <ganesh@veritas.com>,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: [PATCH] Remove duplicate ID in ipaq driver
X-Message-Flag: Warning: May contain useful information
References: <1179348840.6510.16.camel@cunning>
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 16 May 2007 13:59:54 -0700
In-Reply-To: <1179348840.6510.16.camel@cunning> (Ben Collins's message of "Wed, 16 May 2007 16:54:00 -0400")
Message-ID: <ada1whgmqlx.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 16 May 2007 20:59:54.0884 (UTC) FILETIME=[27842440:01C797FD]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 >  	/* The first entry is a placeholder for the insmod-specified device */
 > -	{ USB_DEVICE(0x049F, 0x0003) },

Is it obvious why this patch is correct?  Especially given the
comment just before the line you delete, and the code

	if (vendor) {
		ipaq_id_table[0].idVendor = vendor;
		ipaq_id_table[0].idProduct = product;
	}

in ipaq_init()?

 - R.
