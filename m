Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933051Ab0BFA1J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 19:27:09 -0500
Received: from p01c12o143.mxlogic.net ([208.65.145.66]:40937 "EHLO
	p01c12o143.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754332Ab0BFA1G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 19:27:06 -0500
X-MXL-Hash: 4b6cb75a2480069b-0bd24eb46ad8e710d6c10be1fa2b2b7aa7bb897e
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] linux-2.6.32-directemp
Date: Fri, 5 Feb 2010 16:26:42 -0800
Message-ID: <68FBE0F3CE97264395875AC1C468F22C24A633@mail03.cyberswitching.local>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] linux-2.6.32-directemp
thread-index: AcqmwJEckJLwl9vKTleyFXlnrT0qtgAAZe2w
References: <68FBE0F3CE97264395875AC1C468F22C24A5BD@mail03.cyberswitching.local> <20100205124038.4f1e83ac.akpm@linux-foundation.org> <68FBE0F3CE97264395875AC1C468F22C24A608@mail03.cyberswitching.local> <20100205134600.59eb8fae.akpm@linux-foundation.org> <20100205235833.GA16411@suse.de>
From: "Chris Verges" <chrisv@cyberswitching.com>
To: "Greg KH" <gregkh@suse.de>
Cc: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       "Rob Owings" <rowings@thermistor.com>
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010011101)]
X-MAIL-FROM: <chrisv@cyberswitching.com>
X-SOURCE-IP: [64.81.28.110]
X-AnalysisOut: [v=1.0 c=1 a=4zsJQXJisSY22NXBO5KRuA==:17 a=XOguAvvqdVfLsE33]
X-AnalysisOut: [faEA:9 a=JafeSlGx0Av2SZXOoLoA:7 a=DiSa1zFCwLNu610ss0Eiw5X8]
X-AnalysisOut: [5WoA:4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sorry, but no, this driver will not be accepted, as it can be done
just
> fine from userspace instead of a kernel driver, as discussed before.

Hi Greg,

Sounds good.  I'll still be sending out an updated patch for anyone who
is interested in a kernel driver.  They're welcome to patch in the
driver themselves.

I may be missing some key piece of information about libusb and usbfs,
but it seems like it pushes a lot of the protocol communication off to
the user app.  So if there are several user apps that want to use the
same USB device, they either need a userland library or to re-implement
functionality; is that correct?

What I may be missing is the rationale behind pushing these drivers into
userland libraries and having yet another entity in the FOSS world that
is responsible for managing them.  The kernel seems like an obvious
clearinghouse for software/hardware interactions.  Yes, there may be
lots of drivers, but at least everyone knows where to go for them.  But
like I said before, I may be missing something.

Thanks for the tips about libusb/usbfs!

Chris 
