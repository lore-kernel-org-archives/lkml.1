Return-Path: <linux-kernel-owner+w=401wt.eu-S1763157AbXIZVYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763157AbXIZVYv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 17:24:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760987AbXIZVYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 17:24:43 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:31631 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761355AbXIZVYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 17:24:42 -0400
Date: Wed, 26 Sep 2007 14:13:35 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Konrad Rzeszutek <konrad@darnok.org>
Cc: linux-kernel@vger.kernel.org, pjones@redhat.com, konradr@redhat.com,
       konradr@linux.vnet.ibm.com
Subject: Re: [PATCH] Add iSCSI iBFT support.
Message-Id: <20070926141335.8faa5cb9.randy.dunlap@oracle.com>
In-Reply-To: <20070926184652.GA16369@andromeda.dapyr.net>
References: <20070926184652.GA16369@andromeda.dapyr.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Sep 2007 14:46:52 -0400 Konrad Rzeszutek wrote:

> This patch adds a /sysfs/firmware/ibft/table binary blob which exports
> the iSCSI Boot Firmware Table (iBFT) structure. 
> 
> What is iSCSI Boot Firmware Table?

i.e., what is this binary blob  (?)

I don't see a binary blob in this patch (as stated in the first
sentence).  I'd say that this patch adds methods for exporting
(or exposing) the ibft thru sysfs.

Is there some good reason that the iSCSI connection information
shouldn't be exposed in real sysfs attribute files instead of just
in a binary file?


> It is a mechanism for the iSCSI
> tools to extract from the machine NICs the iSCSI connection information
> so that they can automagically mount the iSCSI share/target. Currently
> the iSCSI information is hard-coded in the initrd.
> 
> The full details of the structure are located at:
> ftp://ftp.software.ibm.com/systems/support/system_x_pdf/ibm_iscsi_boot_firmware_table_v1.02.pdf


---
~Randy
Phaedrus says that Quality is about caring.
