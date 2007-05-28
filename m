Return-Path: <linux-kernel-owner+w=401wt.eu-S1754487AbXE1MIE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487AbXE1MIE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 08:08:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751300AbXE1MHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 08:07:54 -0400
Received: from ppsw-4.csi.cam.ac.uk ([131.111.8.134]:38897 "EHLO
	ppsw-4.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbXE1MHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 08:07:54 -0400
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
In-Reply-To: <1180353701.4242.68.camel@lov.localdomain>
References: <200705272229.21263.rjw@sisk.pl> <20070527220412.GC22687@srcf.ucam.org> <1180304166.3131.66.camel@lov.localdomain> <200705280943.54312.rjw@sisk.pl> <9D3FC259-8391-4C2F-9F0F-AEF6CB3030E8@cam.ac.uk> <1180343171.4242.15.camel@lov.localdomain> <5C7E12A9-DCEB-40AA-B3E6-4A54F4FE8047@cam.ac.uk> <1180353701.4242.68.camel@lov.localdomain>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <EA474B9F-0623-44F1-961E-9258BDACD252@cam.ac.uk>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Garrett <mjg59@srcf.ucam.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, Alan Stern <stern@rowland.harvard.edu>,
       Rob Landley <rob@landley.net>
Content-Transfer-Encoding: 7bit
From: Michael-Luke Jones <mlj28@cam.ac.uk>
Subject: Re: [RFC][PATCH -mm 3/3] PM: Disable _request_firmware before hibernation/suspend
Date: Mon, 28 May 2007 13:07:51 +0100
To: Kay Sievers <kay.sievers@vrfy.org>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 May 2007, at 13:01, Kay Sievers wrote:

> In our development model, users of an interface are expected to  
> improve
> it, because nobody else really knows what's needed. That unfortunately
> didn't happen so far.

Thanks for responding :)

The fact that no-one is told to use the new right way (tm) in any  
available documentation does not help matters improve. One issue is  
that the 'asynchronous' interface seems to rely on the same 'dodgy'  
timeout mechanism as the original request_firmware() call... Looks  
like the lack of a maintainer should be the opportunity for a rework  
of this API.

Michael-Luke Jones
