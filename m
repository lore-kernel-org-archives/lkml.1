Return-Path: <linux-kernel-owner+w=401wt.eu-S1760124AbXKGSiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760124AbXKGSiw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 13:38:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758141AbXKGShk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 13:37:40 -0500
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:53555 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759592AbXKGShi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 13:37:38 -0500
Message-ID: <473205D2.3080703@linux.vnet.ibm.com>
Date: Thu, 08 Nov 2007 00:07:06 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
       kay.sievers@vrfy.org, gregkh@suse.de, Andy Whitcroft <apw@shadowen.org>
Subject: Re: mm snapshot broken-out-2007-11-06-02-32 build failure init/do_mount
References: <200711061033.lA6AXrhT018804@imap1.linux-foundation.org>
In-Reply-To: <200711061033.lA6AXrhT018804@imap1.linux-foundation.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

The kernel build fails with randconfig, with folllowing error

init/do_mounts.c: In function ‘name_to_dev_t’:
init/do_mounts.c:110: error: implicit declaration of function ‘blk_lookup_devt’
make[1]: *** [init/do_mounts.o] Error 1
make: *** [init] Error 2

This is caused by gregkh-driver-block-device.patch, where the function 
blk_lookup_devt is declared within #ifdef CONFIG_BLOCK and randconfig has
not set the CONFIG_BLOCK it.

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
