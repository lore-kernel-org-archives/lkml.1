Return-Path: <linux-kernel-owner+w=401wt.eu-S1757442AbXKTOed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442AbXKTOed (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 09:34:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbXKTOeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 09:34:25 -0500
Received: from wind.enjellic.com ([209.243.13.15]:54723 "EHLO
	wind.enjellic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302AbXKTOeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 09:34:25 -0500
X-Greylist: delayed 1551 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Nov 2007 09:34:24 EST
Message-Id: <200711201408.lAKE8WMp001714@wind.enjellic.com>
From: greg@enjellic.com
Date: Tue, 20 Nov 2007 08:08:32 -0600
Reply-To: greg@enjellic.com
X-Mailer: Mail User's Shell (7.2.5 10/14/92)
To: linux-kernel@vger.kernel.org
Subject: PCMCIA serial_cs driver binding problems.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Good morning to everyone.

I'm working to sort out what appear to be issues with binding of the
serial_cs driver to a PCMCIA wireless card (Zoom).

Card works perfectly in recent 2.6.2[23] kernels if cardmgr is running
and PCMCIA_IOCTL support is in the kernel.  The serial_cs driver
fails, however, to bind in a pure hotplug configuration.  The hotplug
scripts detect card insertion and load the serial_cs module but the
driver doesn't bind to the device.

The slot number (0.0 or 1.0) appears in the /sys/bus/pcmcia/devices
directory after card insertion.  The serial_cs directory also presents
in the /sys/bus/pcmcia/drivers directory secondary to module load.

I've tried to manually echo the device number (0.0 or 1.0) into the
/sys/bus/pcmcia/drivers/serial_cs/bind pseudo-file but nothing
happens.  The device number is present as a binding if cardmgr frobs
things with the pcmcia_ioctl bind commands.

I'm willing to hack on the kernel a bit if additional information or
debugging is needed.

Thanks for any thoughts or guidance.

Best wishes for a productive week.

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"When I am working on a problem I never think about beauty.  I only
 think about how to solve the problem.  But when I have finished, if
 the solution is not beautiful, I know it is wrong."
                                -- Buckminster Fuller
