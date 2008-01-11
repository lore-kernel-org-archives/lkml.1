Return-Path: <linux-kernel-owner+w=401wt.eu-S1761643AbYAKRXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761643AbYAKRXs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 12:23:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760995AbYAKRXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 12:23:40 -0500
Received: from carmdsmtp.sierrawireless.com ([208.81.121.7]:12412 "EHLO
	mx1.sierrawireless.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759882AbYAKRXj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 12:23:39 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] usb-serial: Sierra driver - add devices and update dtr
Date: Fri, 11 Jan 2008 09:24:36 -0800
Message-ID: <3415E2A2AB26944B9159CDB22001004D022572F5@nestea.sierrawireless.local>
In-Reply-To: <20080110195403.GA29384@suse.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] usb-serial: Sierra driver - add devices and update dtr
Thread-Index: AchTwrCYFY65ghlmQY+2EReS+NbboQAsfX3A
References: <1199992265.9266.19.camel@linux-z60t> <20080110195403.GA29384@suse.de>
From: "Kevin Lloyd" <klloyd@sierrawireless.com>
To: "Greg KH" <gregkh@suse.de>
Cc: <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
       <linux-usb-devel@lists.sourceforge.net>
X-OriginalArrivalTime: 11 Jan 2008 17:24:39.0575 (UTC) FILETIME=[D8886270:01C85476]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Those device ids are already in my tree, as it was my understanding
that
> you would not be sending me patches for them :)
You're right, I normally wouldn't, but since someone else already had, I
figured it would be alright.
> I'll split this patch up into something that updates the device ids
and
> then does all of the other changes.  The device ids can go into 2.6.24
> (and -stable if I miss the merge window), but the other changes should
> wait until 2.6.25.
>
> Any objection to this?
Actually some of the added functionality (calc_num_ports) is required
for
device 0x0023 and will be necessary for future devices (should someone 
want to add the VID/PID of a new device it will likely require the added

support).

So my preference would be to please include the other changes in the 
2.6.24 release.

Thanks,
 -Kevin
