Return-Path: <linux-kernel-owner+w=401wt.eu-S1765903AbYCDQs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765903AbYCDQs0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 11:48:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932328AbYCDQr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 11:47:57 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:52866 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932259AbYCDQr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 11:47:56 -0500
Date: Tue, 4 Mar 2008 08:45:57 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, mike.miller@hp.com, iss_storagedev@hp.com
Subject: Re: 2.6.25-rc3-mm1 (CCISS)
Message-Id: <20080304084557.357972a3.randy.dunlap@oracle.com>
In-Reply-To: <20080304011928.e8c82c0c.akpm@linux-foundation.org>
References: <20080304011928.e8c82c0c.akpm@linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Mar 2008 01:19:28 -0800 Andrew Morton wrote:

> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc3/2.6.25-rc3-mm1/

With
CONFIG_BLK_CPQ_DA=m
CONFIG_BLK_CPQ_CISS_DA=m
# CONFIG_CISS_SCSI_TAPE is not set

I'm getting
In file included from drivers/block/cciss.c:230:
drivers/block/cciss_scsi.c:1498:38: error: macro parameters must be comma-separated
drivers/block/cciss.c: In function 'cciss_seq_show_header':
drivers/block/cciss.c:271: error: implicit declaration of function 'cciss_seq_tape_report'
drivers/block/cciss.c: In function 'cciss_proc_write':
drivers/block/cciss.c:392: error: implicit declaration of function 'cciss_engage_scsi'
make[2]: *** [drivers/block/cciss.o] Error 1
make[1]: *** [drivers/block] Error 2
make[1]: *** Waiting for unfinished jobs....

---
~Randy
