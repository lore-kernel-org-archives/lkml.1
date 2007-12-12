Return-Path: <linux-kernel-owner+w=401wt.eu-S1753450AbXLLODn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450AbXLLODn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 09:03:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750905AbXLLODd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 09:03:33 -0500
Received: from rtr.ca ([76.10.145.34]:4496 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750751AbXLLODc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 09:03:32 -0500
Message-ID: <475FEA32.4000509@rtr.ca>
Date: Wed, 12 Dec 2007 09:03:30 -0500
From: Mark Lord <liml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
Cc: Orion Poplawski <orion@cora.nwra.com>, linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: sata_mv hotplug flaky?
References: <fjn8j2$mji$1@ger.gmane.org> <475F60D8.5060903@garzik.org>
In-Reply-To: <475F60D8.5060903@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Orion Poplawski wrote:
>> Not sure what the latest status of sata_mv hotplug should be, but it 
>> seems close.  I'm currently running 2.6.24-0.81.rc4.git7.fc9 with a 
>> MV88SX5081.  Pulled a couple drives and re-added.  One device got 
>> re-added, but the other did not.  It seems like I got the system to 
>> probe and re-add the first drive by doing a "mount -a", but haven't 
>> been able (no idea how) to re-add the second.
>>
> 
> hotplug made great strides with the introduction of the new-EH code, but 
> it still needs a bit of work.  Mark Lord was looking into that, so you 
> can sure your report has been noted...
..

I am not yet looking into sata_mv hotplug, but it is on the list
for early 2008.  There are some peculiarities and errata that need
to be addressed on some of the Marvell chips for this to work reliably.

Target kernel for it is now 2.6.26, with development/testing happening
during the 2.6.25 timeframe (but too late for inclusion there).

If the required tweaks are small and safe enough, then we might be
able to push a few of those out for 2.6.25.  We'll see.

The 2.6.26 kernel should also get full NCQ and PMP support for sata_mv,
and a smattering of other enhancements as well (eg. ATAPI support).

Cheers
