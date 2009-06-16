Return-Path: <linux-kernel-owner+w=401wt.eu-S1760121AbZFPQua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760121AbZFPQua (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 12:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756996AbZFPQuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 12:50:18 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:54211 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbZFPQuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 12:50:16 -0400
Message-ID: <4A37CC79.5000907@oracle.com>
Date: Tue, 16 Jun 2009 09:46:49 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       scsi <linux-scsi@vger.kernel.org>, Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: linux-next: Tree for June 16 (osd)
References: <20090616165923.8ca4ddcb.sfr@canb.auug.org.au>
In-Reply-To: <20090616165923.8ca4ddcb.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt007.oracle.com [141.146.116.16]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010203.4A37CD41.01C2:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20090615:


When
CONFIG_BLK_DEV_OSD=y
CONFIG_SCSI_OSD_INITIATOR=y
# CONFIG_SCSI_OSD_ULD is not set

build fails with

drivers/built-in.o: In function `class_osdblk_remove':
osdblk.c:(.text+0x55376): undefined reference to `osduld_put_device'
drivers/built-in.o: In function `class_osdblk_add':
osdblk.c:(.text+0x5564d): undefined reference to `osduld_path_lookup'
osdblk.c:(.text+0x5584d): undefined reference to `osduld_put_device'


-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
