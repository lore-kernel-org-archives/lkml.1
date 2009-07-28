Return-Path: <linux-kernel-owner+w=401wt.eu-S1752793AbZG1OQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793AbZG1OQ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 10:16:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752155AbZG1OQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 10:16:26 -0400
Received: from mailb.microsoft.com ([131.107.115.215]:51161 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151AbZG1OQZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 10:16:25 -0400
From: Hank Janssen <hjanssen@microsoft.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: Nicolas Palix <npalix@diku.dk>, "gregkh@suse.de" <gregkh@suse.de>,
       "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Staging: hv: Transform PDEVICE_OBJECT and DEVICE_OBJECT
 typedefs into their corresponding structs
Thread-Topic: [PATCH] Staging: hv: Transform PDEVICE_OBJECT and
 DEVICE_OBJECT typedefs into their corresponding structs
Thread-Index: AQHKD15QnyRW1LpSVkGtdjYI2xBQnpCLaI+AgAAJ/wA=
Date: Tue, 28 Jul 2009 14:16:18 +0000
Message-ID: <12B00476-1E0D-46B1-8939-DD36A0C3D197@microsoft.com>
References: <200907281030.45317.npalix@diku.dk>
 <200907281540.31805.arnd@arndb.de>
In-Reply-To: <200907281540.31805.arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-ID: <15d9a3ce-4c3d-4555-bc98-13a7798a4880>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Arnd,

Excellent suggestion. I will submit a patch to call it hv_vmbus_device
which makes it even more clear.

Thanks,

Hank.


On Jul 28, 2009, at 6:41 AM, "Arnd Bergmann" <arnd@arndb.de> wrote:
>>
>>
>
> The patch looks technically correct and improves the code, but
> I'd suggest renaming the structure to fall into a proper namespace.
> The name device_object is extremely generic and should not be
> defined as part of a single driver.
> Simply putting it into a namespace here would make it
> hv_device_object,
> or even mshv_device_object ('hv' still is very generic), but then the
> 'object' part is still redundant. Since it is part of the 'vmbus'
> layer, how about naming it 'struct vmbus_device'?
>
>        Arnd <><
>
