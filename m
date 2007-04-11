Return-Path: <linux-kernel-owner+w=401wt.eu-S1751647AbXDKJUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751647AbXDKJUv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 05:20:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751648AbXDKJUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 05:20:51 -0400
Received: from nn7.de ([85.214.94.156]:58451 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751643AbXDKJUu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 05:20:50 -0400
Subject: evdev* devices change major/minors after suspend/resume (udev?)
From: Soeren Sonnenburg <kernel@nn7.de>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 11 Apr 2007 11:20:47 +0200
Message-Id: <1176283247.14106.10.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

I wonder how one (from the userspace side) should deal with the case
that evdev devices disappear after resume and reappear under a different
name/different major/minor (i.e. evdev1 can become evdev4).

The application in mind scans all evdev devices, opens the ones matching
certain properties and then processes events on them.

Now the problem is that after resume devices disappear, so the
application rescans+reopens the evdev's BUT some of the evdevs are just
not available right after resume but appear at some point later in time.

Is there a way to wait till all evdev's are recreated / ask for udev to
settle ? Or what is the proposed way of dealing with that ?

Very concrete it is this evdev that may be missing... and just FYI this
also seems to cause trouble in Xorg - sometimes the appletouch mouse is
not yet back...

/dev/input/by-id/usb-Apple_Computer_Apple_Internal_Keyboard_._Trackpad-event-kbd -> ../event5

Any hints welcome,
Soeren
-- 
Sometimes, there's a moment as you're waking, when you become aware of
the real world around you, but you're still dreaming.
