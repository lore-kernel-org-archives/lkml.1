Return-Path: <linux-kernel-owner+w=401wt.eu-S1759818AbYAQXO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759818AbYAQXO3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 18:14:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754259AbYAQXOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 18:14:20 -0500
Received: from carmdsmtp.sierrawireless.com ([208.81.121.7]:43157 "EHLO
	mx1.sierrawireless.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbYAQXOS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 18:14:18 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] usb-serial: Sierra driver - add devices and update dtr
Date: Thu, 17 Jan 2008 15:15:23 -0800
Message-ID: <3415E2A2AB26944B9159CDB22001004D02296DC3@nestea.sierrawireless.local>
In-Reply-To: <20080117180453.GA7780@suse.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] usb-serial: Sierra driver - add devices and update dtr
Thread-Index: AchZS6qBomBITVnkQQSlyFvveyCuIgAD9n1g
References: <1199992265.9266.19.camel@linux-z60t> <20080110195403.GA29384@suse.de> <3415E2A2AB26944B9159CDB22001004D022572F5@nestea.sierrawireless.local> <20080111210234.GA3070@suse.de> <3415E2A2AB26944B9159CDB22001004D022577B3@nestea.sierrawireless.local> <20080117180453.GA7780@suse.de>
From: "Kevin Lloyd" <klloyd@sierrawireless.com>
To: "Greg KH" <gregkh@suse.de>
Cc: <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
       <linux-usb-devel@lists.sourceforge.net>
X-OriginalArrivalTime: 17 Jan 2008 23:15:24.0335 (UTC) FILETIME=[D6AA6BF0:01C8595E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Correct, the 0x0023 is the only newly added device that requires the
new
> > features.
>
> Does that mean things will not work for this device if it is added to
> the device table, without the code updates?
Adding the device will not break the driver (assuming you remove the
tag).

> And is this device even public yet?

No, but we are trying to add native support for devices into kernels
well 
before they are released in an effort give better native support to
end-users.

> > When do you expect the other changes will be propagated to the
kernel?
> > Would it be in a 2.6.24.x point release or will they have to wait
until
> > 2.6.25?
>
> They will have to wait until 2.6.25, they are too big to go into
2.6.24
> (we are in severe bug-fix mode only right now for .24).
Darn.

Thanks,
 -Kevin

