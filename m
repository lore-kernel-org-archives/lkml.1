Return-Path: <linux-kernel-owner+w=401wt.eu-S1760722AbXK1Nrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760722AbXK1Nrl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 08:47:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759904AbXK1Nrb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 08:47:31 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:51582 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759879AbXK1Nra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 08:47:30 -0500
Message-ID: <474D716B.30608@garzik.org>
Date: Wed, 28 Nov 2007 08:47:23 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Kjartan Maraas <kmaraas@broadpark.no>, Tomas Carnecky <tom@dbservice.com>,
       Pavel Machek <pavel@ucw.cz>, linux-ide@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>, Mark Lord <liml@rtr.ca>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: laptop reboots right after hibernation
References: <473730F6.2010900@dbservice.com> <20071118105214.GB7299@ucw.cz> <4740692E.7010801@dbservice.com> <47409DA3.7070909@dbservice.com> <1195551141.2792.3.camel@localhost.localdomain> <474CBFB6.4020105@gmail.com> <1196253340.2884.1.camel@localhost.localdomain> <474D6EA7.2000506@gmail.com>
In-Reply-To: <474D6EA7.2000506@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> 2. Filter out certain commands from ACPI.  I definitely don't like BIOS
> locking up random features via _GTF commands.  It makes debugging difficult.

I agree.

Take a look at what Alan has been doing for the "trusted" command stuff.

At the very least we should definitely blare a warning into the log if 
the BIOS is taking away key features from the user.

	Jeff


