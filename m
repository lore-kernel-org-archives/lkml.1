Return-Path: <linux-kernel-owner+w=401wt.eu-S1752151AbXBWJiI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151AbXBWJiI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 04:38:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752158AbXBWJiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 04:38:07 -0500
Received: from hqemgate02.nvidia.com ([216.228.112.143]:16250 "EHLO
	HQEMGATE02.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151AbXBWJiG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 04:38:06 -0500
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH] ACPI driver support for pata
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Date: Fri, 23 Feb 2007 01:36:04 -0800
Message-ID: <DBFABB80F7FD3143A911F9E6CFD477B00E48D718@hqemmail02.nvidia.com>
In-Reply-To: <45DE3207.6020707@shaw.ca>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] ACPI driver support for pata
thread-index: AcdW3/aXM9krtdrITXOG7UY88PkljQATODHA
References: <fa.IjFXvdcBtWXV65pRZipPd0NVTOA@ifi.uio.no> <45DD2E12.6000705@shaw.ca> <45DD3F20.7050907@pobox.com> <20070222142439.50cff3e9@lxorguk.ukuu.org.uk> <45DDCEC4.7050208@garzik.org> <20070222182939.56d43a68@lxorguk.ukuu.org.uk> <45DE3207.6020707@shaw.ca>
From: "Allen Martin" <AMartin@nvidia.com>
To: "Robert Hancock" <hancockr@shaw.ca>, "Alan" <alan@lxorguk.ukuu.org.uk>
Cc: "Jeff Garzik" <jeff@garzik.org>, <akpm@osdl.org>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 23 Feb 2007 09:36:05.0993 (UTC) FILETIME=[0A84B590:01C7572E]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Couldn't be do this generically inside libata core somehow, 
> i.e. try to 
> use ACPI to set the proper mode and fall back to the driver-specific 
> mode setting code if that didn't work? I think if we could do that it 
> would solve a number of problems (i.e. we could prevent it from doing 
> this on SATA controllers which appear to be IDE based on the PCI ID, 
> like the NVIDIA SATA controllers, since the _GTM and _STM 
> methods seem 
> to have undefined behavior on SATA). 

_GTM and _STM don't have undefined behavior on SATA.  They are there for
compatability with the MS Windows ATA driver.  Any SATA device that
reports PCI class code 0101 should implement them if that controller is
supposed to work on Windows.  They are NOPs for SATA controllers
generally.

-----------------------------------------------------------------------------------
This email message is for the sole use of the intended recipient(s) and may contain
confidential information.  Any unauthorized review, use, disclosure or distribution
is prohibited.  If you are not the intended recipient, please contact the sender by
reply email and destroy all copies of the original message.
-----------------------------------------------------------------------------------
