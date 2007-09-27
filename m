Return-Path: <linux-kernel-owner+w=401wt.eu-S1758584AbXI0RIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758584AbXI0RIb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 13:08:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757029AbXI0RIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 13:08:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58981 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757074AbXI0RIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 13:08:23 -0400
Message-ID: <46FBE30D.7010108@zytor.com>
Date: Thu, 27 Sep 2007 10:06:21 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Konrad Rzeszutek <konrad@darnok.org>
CC: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       pjones@redhat.com, konradr@redhat.com, konradr@linux.vnet.ibm.com
Subject: Re: [PATCH] Add iSCSI iBFT support.
References: <20070926184652.GA16369@andromeda.dapyr.net> <20070926142950.46bbfcd2.randy.dunlap@oracle.com> <200709262052.44845.konrad@darnok.org>
In-Reply-To: <200709262052.44845.konrad@darnok.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Konrad Rzeszutek wrote:
>>> +config ISCSI_IBFT
>>> +	tristate "iSCSI Boot Firmware Table Attributes"
>>> +	depends on X86
>> why only on X86?
> 
> PowerPC exports this data via the OpenFirmware so it already shows in 
> the /sysfs entries. I was thinking to combine those sysfs entries under this 
> code, but that is something in the future.
> 
> In regards to all other platforms, I figured I would only make it supported 
> under platforms that have been tested. Is there anything that stops this from 
> working for example of IA64? Well no. The hardware that supports the iBFT is 
> either in the BIOS or in NICs - so the SGI or HP boxes _should_ work, however 
> I am not comfortable to make it supported unless I've tested it.
> 

It should, presumably, depend on ACPI, rather than on X86...?

	-hpa

