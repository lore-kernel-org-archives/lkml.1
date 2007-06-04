Return-Path: <linux-kernel-owner+w=401wt.eu-S1758692AbXFDRst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758692AbXFDRst (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 13:48:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754080AbXFDRsj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 13:48:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:41769 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753406AbXFDRsh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 13:48:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,381,1175497200"; 
   d="scan'208";a="93344045"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: multiple xor_block() functions
Date: Mon, 4 Jun 2007 10:48:35 -0700
Message-ID: <0C7297FA1D2D244A9C7F6959C0BF1E5201F034A9@azsmsx413.amr.corp.intel.com>
In-Reply-To: <20070602185746.GI5500@stusta.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: multiple xor_block() functions
Thread-Index: AcelR+jJ46Yac1FNQK+f8ZjzYuYKMABiEySA
From: "Williams, Dan J" <dan.j.williams@intel.com>
To: "Adrian Bunk" <bunk@stusta.de>, <mingo@redhat.com>, <neilb@suse.de>,
       "John W. Linville" <linville@tuxdriver.com>, "Jouni Malinen" <j@w1.fi>
Cc: <linux-raid@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 04 Jun 2007 17:48:36.0176 (UTC) FILETIME=[93858D00:01C7A6D0]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Adrian Bunk [mailto:bunk@stusta.de]
> include/linux/raid/xor.h:extern void xor_block(unsigned int count,
unsigned
> int bytes, void **ptr);
> drivers/md/xor.c:xor_block(unsigned int count, unsigned int bytes,
void **ptr)
> drivers/md/xor.c:EXPORT_SYMBOL(xor_block);
> 
> and
> 
> net/ieee80211/ieee80211_crypt_ccmp.c:static inline void xor_block(u8 *
b, u8 *
> a, size_t len)
> 
> 
> At least one of them has to be renamed.
> 
I'll rename the raid version to 'xor_blocks' in the md-accel series.  [
I would have suggested xor_n_blocks except that xor_blocks is limited to
5-blocks (MAX_XOR_BLOCKS) ]

> 
> cu
> Adrian
> 

Dan
