Return-Path: <linux-kernel-owner+w=401wt.eu-S1760324AbXGBOzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760324AbXGBOzm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 10:55:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753370AbXGBOzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 10:55:36 -0400
Received: from mail29.messagelabs.com ([216.82.249.147]:50468 "HELO
	mail29.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752856AbXGBOzf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 10:55:35 -0400
X-VirusChecked: Checked
X-Env-Sender: Scott_Kilau@digi.com
X-Msg-Ref: server-13.tower-29.messagelabs.com!1183388132!35326628!1
X-StarScan-Version: 5.5.12.11; banners=-,-,-
X-Originating-IP: [66.77.174.21]
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH][RFC] Remove support for the orphaned, obsolete Digi EPCA driver.
Date: Mon, 2 Jul 2007 09:56:50 -0500
Message-ID: <335DD0B75189FB428E5C32680089FB9F012DD309@mtk-sms-mail01.digi.com>
In-Reply-To: <20070702151534.2728ae63@the-village.bc.nu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH][RFC] Remove support for the orphaned, obsolete Digi EPCA driver.
Thread-Index: Ace8ssZk0vvM6UuuRumh1gwnPllROwAAlxgg
References: <Pine.LNX.4.64.0707020906530.19712@localhost.localdomain><20070702144605.5cf99b3a@the-village.bc.nu><Pine.LNX.4.64.0707020945290.18113@localhost.localdomain> <20070702151534.2728ae63@the-village.bc.nu>
From: "Kilau, Scott" <Scott_Kilau@digi.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Robert P. J. Day" <rpjday@mindspring.com>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Eng.Linux" <Eng.Linux@digi.com>
X-OriginalArrivalTime: 02 Jul 2007 14:56:52.0131 (UTC) FILETIME=[39660F30:01C7BCB9]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

> Last time I poked at the tools they were working under 2.6 with some
> trivial compile fixes. Ideally this driver would be trimmed 
> to ISA only
> and the newer dgrs drivers merged but latter half appears to 
> be something
> digi have no interest in

I would be very surprised if anyone uses/could use the existing "epca"
drivers in the kernel.

As Robert has noticed, they would *not* work out-of-the-box, and would
require tweaking in the userspace utils as well as the kernel code as
well.

We here at Digi would love to see the "epca" driver go away from the
kernel sources and replace it with our new "dgap" open source driver,
but I can understand where you are coming from Alan.

As for merging the new Digi driver (dgap) source code that actually
work under 2.6 kernel, I attempted that a few years ago...

It did not go well, which I know and understand is expected for
merging ANY new driver into the kernel.

However, it was discovered during that time, there are
fundamental things/changes required to the driver that would 
end up crippling our driver in the "usability" department.

(Probably the biggest obstacle, was the extra ioctls to
manage "Digi" specific things, and other hooks that are
simply not permitted in in-kernel code)

Trust me, I *know* the pain of keeping the driver out-of-tree
with the constant flux in the kernel API, and I understand that
most people here say its completely self-inflicted...

But massively crippling the driver from a usability POV,
just simply isn't an option.

Thus, I have to keep the driver, open source, but out-of-tree,
and take the lumps of the constantly changing kernel API as
they are dished out.

Scott Kilau
Digi International
