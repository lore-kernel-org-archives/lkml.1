Return-Path: <linux-kernel-owner+w=401wt.eu-S1755905AbYGPGEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905AbYGPGEU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 02:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751794AbYGPGEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 02:04:12 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:38303 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465AbYGPGEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 02:04:11 -0400
Message-ID: <487D8F57.2060502@garzik.org>
Date: Wed, 16 Jul 2008 02:04:07 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Chris Adams <cmadams@hiwaay.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel,
  use it in more drivers.
References: <aPHZW-47Y-17@gated-at.bofh.it> <aPIje-4ST-15@gated-at.bofh.it> <aPV6W-3jN-41@gated-at.bofh.it> <aPX8A-7qb-21@gated-at.bofh.it> <aPXii-7G3-25@gated-at.bofh.it> <aPXs2-7Vn-25@gated-at.bofh.it> <aPXUQ-aU-1@gated-at.bofh.it> <aPY4D-G7-23@gated-at.bofh.it> <aPZ0H-2ls-21@gated-at.bofh.it> <aPZap-2zq-15@gated-at.bofh.it> <20080716001038.GA1242918@hiwaay.net>
In-Reply-To: <20080716001038.GA1242918@hiwaay.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Adams wrote:
> Once upon a time, Jeff Garzik  <jeff@garzik.org> said:
>> * Red Hat driver disks.  The build process is unaware of the need to 
>> bundle firmware.  Any use with Fedora (or, later, RHEL) will result in a 
>> non-working driver, for the simple reason that firmware is not copied 
>> onto the image.
> 
> Then Red Hat driver disks are already broken, as there are current
> modules (e.g. qla2xxx) that require external firmware.

That doesn't change the problem any.  There are still users of this 
thing, regardless of what appellations are attached.


>> * Embedded projects like OpenWRT, that divide up kernel modules into 
>> multiple packages.  Since it's not just one big package, you have to 
>> update each package's list of files to include the newly split-out 
>> firmwares.  Failure to do so results in a successful build set of 
>> packages... of drivers that lack their firmware.
> 
> AFAIK OpenWRT and the like don't just throw in random new kernel
> releases without at least reading release notes and testing.

Sure.  The difference here is that we usually take care to make sure 
there is some way for the distributor to continue configuring their 
system in the manner known to work, while developing and testing new stuff.

But in this case, that option was not available to distributors (but 
hopefully it will be, in another day or two).

	Jeff


