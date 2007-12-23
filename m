Return-Path: <linux-kernel-owner+w=401wt.eu-S1755532AbXLWA4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532AbXLWA4a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 19:56:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754040AbXLWA4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 19:56:21 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:51607 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754016AbXLWA4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 19:56:21 -0500
Message-ID: <476DB22F.60709@garzik.org>
Date: Sat, 22 Dec 2007 19:56:15 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Robert Hancock <hancockr@shaw.ca>, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [patch] Make MMCONFIG space (extended PCI config space) a driver
 opt-in issue
References: <fa.pFsY/52FEkQYqrDPnPMxmcUOsRY@ifi.uio.no> <476D39C5.9080409@shaw.ca> <20071222192532.GA5282@suse.de>
In-Reply-To: <20071222192532.GA5282@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> But it is that device, and the driver that controls this device that
> cares about the extended config space.  So it's fair to push this onto
> the driver if needed, instead of forcing the pci core to just blindly
> guess for all devices, and getting it wrong...


Nothing is being forced to guess.  You make sure the broken chipsets 
never enable mmconfig...  just like we do for plenty of other errata.

	Jeff


