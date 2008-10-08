Return-Path: <linux-kernel-owner+w=401wt.eu-S1756671AbYJHWzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671AbYJHWzt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 18:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751314AbYJHWzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 18:55:41 -0400
Received: from wacom-nt10.wacom.com ([204.119.25.43]:32639 "EHLO
	wacom-nt10.wacom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbYJHWzk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 18:55:40 -0400
X-Greylist: delayed 807 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Oct 2008 18:55:40 EDT
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Wacom tablet not working with 2.6.27-rc: kernel or X.org driver fault?
Date: Wed, 8 Oct 2008 15:42:11 -0700
Message-ID: <6753EB6004AFF34FAA275742C104F95271BCC8@wacom-nt10.wacom.com>
In-Reply-To: <20081008231131.4feb01cd@diego-desktop>
References: <20081008231131.4feb01cd@diego-desktop>
From: "Ping Cheng" <pingc@wacom.com>
To: "dcg" <diegocg@gmail.com>, <dmitry.torokhov@gmail.com>
Cc: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bug with ubuntu is related to kernel 2.6.26 and the user's newer
tablet.  They have to upgrade wacom.ko from linuxwacom themselves or
wait for ubuntu to do the job for them.  That has nothing to do with
kernel.org.

For the patch, it is related kernel 2.6.27.  We, linuxwacom, doesn't
support 2.6.27 yet (it is on our to-do list).  We are waiting for a
final testing among users before submitting a patch to kernel.org for
the newly added tablets:  Bamboo1, DTU, and USB Tablet PCs. We'll
probably submit the patch within 2 weeks. But the patch will most likely
go to 2.6.28.

Feel free to email me if anything above confuses you.

Ping

-----Original Message-----
From: dcg [mailto:diegocg@gmail.com] 
Sent: Wednesday, October 08, 2008 2:12 PM
To: Ping Cheng; dmitry.torokhov@gmail.com; linux-kernel@vger.kernel.org
Subject: Wacom tablet not working with 2.6.27-rc: kernel or X.org driver
fault?

Hi, I just updated to Ubuntu Intrepid testing sources, which include
X.org 7.4, and as kernel I'm using the latest Linus' tree. And my
wacom tablet has stopped working properly, just like described in
https://bugs.launchpad.net/ubuntu/+source/wacom-tools/+bug/260675

As this bug appeared when I updated X.org I'd blame the X driver for
this bug (it's not a kernel regression), but there's people pointing
to a kernel patch [1] that updates the kernel driver to the latest
version to get this problem fixed, so I ask: Is there some bug in the
kernel wacom module that can be sent as a simple fix to -stable (2.6.27
will be released really soon), or have the linuxwacom people decided to
change the compatibility between the X <-> kernel wacom interfaces
without pushing the changes to one side, and then we must wait to 2.6.28
because it's an "improvement"?

It'd be interesting to get this issue fixed ASAP, as having stable
releases of X.org and Linux which can't work together is not very
nice, specially for the ones of us that use a tablet as mouse.

[1]: http://launchpadlibrarian.net/17948041/wacom-1.49.patch
