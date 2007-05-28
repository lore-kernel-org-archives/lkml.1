Return-Path: <linux-kernel-owner+w=401wt.eu-S1761689AbXE1K0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761689AbXE1K0m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 06:26:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752646AbXE1K0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 06:26:34 -0400
Received: from ppsw-4.csi.cam.ac.uk ([131.111.8.134]:59821 "EHLO
	ppsw-4.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbXE1K0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 06:26:34 -0400
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
In-Reply-To: <1180343171.4242.15.camel@lov.localdomain>
References: <200705272229.21263.rjw@sisk.pl> <20070527220412.GC22687@srcf.ucam.org> <1180304166.3131.66.camel@lov.localdomain> <200705280943.54312.rjw@sisk.pl> <9D3FC259-8391-4C2F-9F0F-AEF6CB3030E8@cam.ac.uk> <1180343171.4242.15.camel@lov.localdomain>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <5C7E12A9-DCEB-40AA-B3E6-4A54F4FE8047@cam.ac.uk>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Garrett <mjg59@srcf.ucam.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, Alan Stern <stern@rowland.harvard.edu>,
       Rob Landley <rob@landley.net>
Content-Transfer-Encoding: 7bit
From: Michael-Luke Jones <mlj28@cam.ac.uk>
Subject: Re: [RFC][PATCH -mm 3/3] PM: Disable _request_firmware before hibernation/suspend
Date: Mon, 28 May 2007 11:26:28 +0100
To: Kay Sievers <kay.sievers@vrfy.org>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 May 2007, at 10:06, Kay Sievers wrote:

> The underlying issue are the driver authors, that's not so easy to
> fix. :)

Sorry, I know this maybe be unintentional, but comments like this  
make me somewhat angry.

If there is no decent documentation as to how to do it the right way  
(tm), how do you expect people to do it the right way (tm)?

> Any timeout for a
> firmware-request is just a broken concept, the request should wait
> forever, to be fulfilled or canceled from userspace when it's ready.

What I wrote above is especially true when the in-kernel APIs  
themselves do things the wrong way (tm) themselves. Thus, even more  
thought is required to work around this imperfect behaviour in a sane  
manner. And without documentation, every single device driver author  
has to go through this thought process themselves. Unsurprisingly,  
they often get it wrong. But as there's no decent documentation to do  
it right, it's *not* their fault. I'd suggest it's more the fault of  
the core kernel devs who fail to fix up a questionable firmware  
loading interface, then fail to document how to work around its  
shortcomings.

Again, apologies if this sounds angry, I don't want to start an  
argument. But as someone just starting out here, this kind of thing  
can be very frustrating, as even with the best will in the world,  
achieving the right way (tm) is basically impossible if those in the  
know about what the right way (tm) is fail to share this information.

Michael-Luke Jones

