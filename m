Return-Path: <linux-kernel-owner+w=401wt.eu-S1756054AbYJHVMN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054AbYJHVMN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 17:12:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754750AbYJHVL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 17:11:57 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:55381 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754724AbYJHVL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 17:11:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:x-mailer:mime-version:content-type
         :content-transfer-encoding;
        b=NOb1B2l/g7XxMZg96SJ7Ahqtillj71NQQomDGhodVFdjyC94U24qzZRqlX117FHOGa
         4BVb7sI9MQ1v/etXCDiCSDo6Ls2e9+Df8EkbA5j8ni46nXLlJSFlS8PSzKpOUOy/rB5S
         22wn5085RC6Khi2FjoT7LsLw4ps6ljtk2mpsY=
Date: Wed, 8 Oct 2008 23:11:31 +0200
From: dcg <diegocg@gmail.com>
To: pingc@wacom.com, dmitry.torokhov@gmail.com, linux-kernel@vger.kernel.org
Subject: Wacom tablet not working with 2.6.27-rc: kernel or X.org driver
 fault?
Message-ID: <20081008231131.4feb01cd@diego-desktop>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
