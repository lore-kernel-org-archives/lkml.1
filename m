Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933057Ab0BYRaK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 12:30:10 -0500
Received: from smtp.microsoft.com ([131.107.115.215]:30878 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932994Ab0BYRaI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 12:30:08 -0500
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Greg KH <greg@kroah.com>, Hank Janssen <hjanssen@microsoft.com>
CC: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: Problem with auto-detecting a HV environment from within Linux
Thread-Topic: Problem with auto-detecting a HV environment from within Linux
Thread-Index: AQHKtjnpPG+DB1+VDUmGCDmANJRAY5HXEhsA
Date: Thu, 25 Feb 2010 17:30:29 +0000
Message-ID: <1FB5E1D5CA062146B38059374562DF725B6A4277@TK5EX14MBXC130.redmond.corp.microsoft.com>
References: <20100225164436.GA3310@kroah.com>
In-Reply-To: <20100225164436.GA3310@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Greg KH [mailto:greg@kroah.com]
> So, is there a way to "know" ahead of time if we are in a HV guest
> environment?

Here is some info from dmesg, which shows "VRTUAL MICROSFT".
ACPI: RSDT (v001 VRTUAL MICROSFT 0x03000919 MSFT 0x00000097) @ 0x000000001fff0000
ACPI: FADT (v002 VRTUAL MICROSFT 0x03000919 MSFT 0x00000097) @ 0x000000001fff0200
ACPI: WAET (v001 VRTUAL MICROSFT 0x03000919 MSFT 0x00000097) @ 0x000000001fff0b00
ACPI: SLIC (v001 VRTUAL MICROSFT 0x03000919 MSFT 0x00000097) @ 0x000000001fff0b40
ACPI: OEM0 (v001 VRTUAL MICROSFT 0x03000919 MSFT 0x00000097) @ 0x000000001fff0d40
ACPI: SRAT (v002 VRTUAL MICROSFT 0x03000919 MSFT 0x00000097) @ 0x000000001fff0600
ACPI: MADT (v001 VRTUAL MICROSFT 0x03000919 MSFT 0x00000097) @ 0x000000001fff0300
ACPI: OEMB (v001 VRTUAL MICROSFT 0x03000919 MSFT 0x00000097) @ 0x000000001ffff240
ACPI: DSDT (v001 MSFTVM MSFTVM02 0x00000002 INTL 0x02002026) @ 0x0000000000000000

Thanks,

- Haiyang

