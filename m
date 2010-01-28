Return-Path: <linux-kernel-owner+w=401wt.eu-S1754779Ab0A1HNE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779Ab0A1HNE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 02:13:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754609Ab0A1HND
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 02:13:03 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:53443 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298Ab0A1HNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 02:13:02 -0500
MIME-Version: 1.0
Date: Thu, 28 Jan 2010 17:13:00 +1000
Message-ID: <1d3f23371001272313i62fc9158se4cd9173f196fb12@mail.gmail.com>
Subject: UIO / of_genirq driver
From: John Williams <john.williams@petalogix.com>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Cc: Grant Likely <grant.likely@secretlab.ca>, w.sang@pengutronix.de,
       magnus.damm@gmail.com, hjk@linutronix.de, gregkh@suse.de,
       linuxppc-dev@lists.ozlabs.org,
       devicetree-discuss <devicetree-discuss@lists.ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I came across this thread/patchset from around June last year:

http://lists.ozlabs.org/pipermail/linuxppc-dev/2009-June/073086.html

where Wolfgang proposed a generic OF-driven UIO driver.  The
discussion seemed to stall after Grant Likely indicated he didn't like
the use of a linux-specific compatible binding in the device tree
(compatible="generic-uio").

I guess I have a couple of questions:

 * did this patchset go anywhere?  I've been using it here the last
few days and it works great.

and more generally:

 * Is there a better way to handle the OF bindings for this sort of thing?

Grant's complaint seems to come up often - when you have generic
controllers in a system (SPI/I2C also spring to mind), we need a way
of signalling somehow to the kernel that each instance has a
particular usage intended.

However, the device-tree guys complain whenever anyone tries to encode
anything non-hardware related into the DTS itself.

I guess I'd like to just open up a discussion, see if there's been any
progress towards a general solution.

Thanks,

John
-- 
John Williams
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com  p: +61-7-30090663  f: +61-7-30090663
