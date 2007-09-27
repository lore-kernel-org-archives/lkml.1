Return-Path: <linux-kernel-owner+w=401wt.eu-S1758150AbXI0RYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758150AbXI0RYa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 13:24:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755911AbXI0RYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 13:24:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52056 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853AbXI0RYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 13:24:22 -0400
Message-ID: <46FBE5D2.6090306@zytor.com>
Date: Thu, 27 Sep 2007 10:18:10 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Peter Jones <pjones@redhat.com>
CC: Konrad Rzeszutek <konrad@darnok.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       konradr@redhat.com, konradr@linux.vnet.ibm.com
Subject: Re: [PATCH] Add iSCSI iBFT support.
References: <20070926184652.GA16369@andromeda.dapyr.net> <20070926142950.46bbfcd2.randy.dunlap@oracle.com> <200709262052.44845.konrad@darnok.org> <46FBE30D.7010108@zytor.com> <46FBE478.6040602@redhat.com>
In-Reply-To: <46FBE478.6040602@redhat.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Jones wrote:
>>
>> It should, presumably, depend on ACPI, rather than on X86...?
> 
> Actually no.  That /should/ be the correct answer, but none of the
> hardware vendors actually provide the table via ACPI yet.  Also, if they
> did, the support for /sys/firmware/acpi/tables/* would be sufficient
> instead of having this code *at all*.
> 

Is there anything other than the discovery which is braindead about
iBFT?  If so, can the tables code be taught to look for this additional
table instead of having all its own mechanism?

(Sorry - I don't really know the ACPI code all that well.)

	-hpa
