Return-Path: <linux-kernel-owner+w=401wt.eu-S1759708AbYEMIhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759708AbYEMIhw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 04:37:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757250AbYEMIhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 04:37:45 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:51324 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756701AbYEMIho convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 04:37:44 -0400
X-IronPort-AV: E=Sophos;i="4.27,478,1204520400"; 
   d="scan'208";a="53448974"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 1/1] [PCMCIA]: add support the CF PCMCIA driver for Blackfin
Date: Tue, 13 May 2008 09:36:24 +0100
Message-ID: <8A42379416420646B9BFAC9682273B6D015A1974@limkexm3.ad.analog.com>
In-Reply-To: <20080512113726.GB15305@flint.arm.linux.org.uk>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/1] [PCMCIA]: add support the CF PCMCIA driver for Blackfin
Thread-Index: Aci0JVIAFqs7efndRNmFHxQ1cBMMvwAruqmQ
References: <1210589200-12431-1-git-send-email-cooloney@kernel.org> <20080512113726.GB15305@flint.arm.linux.org.uk>
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: "Russell King" <rmk+lkml@arm.linux.org.uk>,
       "Bryan Wu" <cooloney@kernel.org>
Cc: <linux-pcmcia@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
       "Michael Hennerich" <michael.hennerich@analog.com>
X-OriginalArrivalTime: 13 May 2008 08:36:26.0362 (UTC) FILETIME=[6EB71DA0:01C8B4D4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Russell King [mailto:rmk@arm.linux.org.uk] On Behalf Of Russell
King
>Sent: Montag, 12. Mai 2008 13:37
>To: Bryan Wu
>Cc: linux-pcmcia@lists.infradead.org; linux-kernel@vger.kernel.org;
Michael
>Hennerich
>Subject: Re: [PATCH 1/1] [PCMCIA]: add support the CF PCMCIA driver for
>Blackfin
>
>On Mon, May 12, 2008 at 06:46:40PM +0800, Bryan Wu wrote:
>> +static struct device_driver bfin_cf_driver = {
>> +	.name		= (char *) driver_name,
>> +	.bus		= &platform_bus_type,
>> +	.probe		= bfin_cf_probe,
>> +	.remove		= __devexit_p(bfin_cf_remove),
>> +	.suspend 	= pcmcia_socket_dev_suspend,
>> +	.resume 	= pcmcia_socket_dev_resume,
>> +};
>
>NAK.  All platform device drivers must be of type 'struct
platform_driver'.

Haven't looked at the code since a great while...

ACK - were going to update.

Best regards,
Michael


>
>--
>Russell King
> Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
> maintainer of:
