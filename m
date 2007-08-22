Return-Path: <linux-kernel-owner+w=401wt.eu-S934037AbXHVVw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934037AbXHVVw1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 17:52:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763710AbXHVVwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 17:52:19 -0400
Received: from dax.msoe.edu ([155.92.194.41]:39312 "EHLO mx.msoe.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763597AbXHVVwT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 17:52:19 -0400
Message-ID: <17603.12.191.136.2.1187819526.squirrel@myweb.msoe.edu>
In-Reply-To: <20070822185544.GA6002@kroah.com>
References: <1187716018.731090.165620@j4g2000prf.googlegroups.com>
    <20070821171018.C964B5F778@attila.bofh.it>
    <39877.198.169.188.225.1187733834.squirrel@myweb.msoe.edu>
    <20070822054615.GA23336@kroah.com>
    <45719.198.169.188.225.1187793693.squirrel@myweb.msoe.edu>
    <20070822185544.GA6002@kroah.com>
Date: Wed, 22 Aug 2007 16:52:06 -0500 (CDT)
Subject: Re: Restricting CDC-ACM devices
From: "Nate" <stoddarn@msoe.edu>
To: "Greg KH" <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.10a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-MSOE-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-MSOE-MailScanner-From: stoddarn@msoe.edu
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for your responses.  Please don't take my repeated questioning
of your answers as me being difficult, I'm just trying to get a better
understanding.


> Well, just messing with the device ids is not that tough of a patch to
> keep up to date over time, so you might just try that if necessary.

That is a good point.  I may also be adding some extra logic to check
other fields to confirm compatibility before allowing a usb device to be
bound to the CDC-ACM driver.  That is still probably pretty small piece of
code in the probe function, but I'm just concerned that over time more
logic would be added and other developers will be maintaining the code.


> Yes.  You can manually bind and unbind all PCI and USB devices from
> their drivers from userspace.  So you do have full control over this
> already, no kernel changes needed.

Does this require my userspace applications to poll the USB devices
(/proc/bus/usb/devices) and then disconnect/connect my driver every time a
USB device using CDC-ACM is connected?  Is this what is normally done? 
Does this cause a noticeable performance hit when the driver is cycled
like this?  If I don't enable CDC-ACM in make menuconfig, can I still bind
it to a USB device from userspace?


I don't know if this matters, but I wanted to add some use case details:
This driver will be running on a <200 MHz processor and there can be a
number of connects/disconnect of the device in a short time from the
users.

Thanks,
-Nate

