Return-Path: <linux-kernel-owner+w=401wt.eu-S1753294AbZLAKzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294AbZLAKzA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 05:55:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752900AbZLAKy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 05:54:59 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:44210 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702AbZLAKy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 05:54:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=X9gDVlGAwgDNwIBQ89A0CBNSc3fhFH0+IxBcyKlagPYVl9Qi0/agR76EmlcrLngJG6
         DoDf3ixiqs96WkB1321VlGs3OYR9vJl3/BimxQtE9miNq1eB5fLD8SgiHRQah+OljL//
         doLCVWa1q9ApYJ308IhIOOnX7Ikv7/V5WkbHY=
MIME-Version: 1.0
Date: Tue, 1 Dec 2009 11:55:03 +0100
Message-ID: <ffd8902a0912010255k1bad9886l420b32df8c66551f@mail.gmail.com>
Subject: Problem KMS: TTM Failed moving buffer. Proposed placement 0x00060004 
	/ Out of aperture space or DRM memory quota && invalid framebuffer id
From: Christian Hartmann <cornogle@googlemail.com>
To: linux-kernel@vger.kernel.org
Cc: airlied@gmail.com, jglisse@redhat.com, dri-devel@lists.sf.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Todays test with KMS  w/o AGP (radeon.agopmode=-1)


Starting Xorg I got instead of a normal X session a GDM login again,
the last dmesg messages are:


[  904.459254] wlan1: associated
[ 1459.645513] [TTM] Failed moving buffer. Proposed placement 0x00060004
[ 1459.645525] [TTM] Out of aperture space or DRM memory quota.
[ 1459.645533] [drm:radeon_object_list_validate] *ERROR* radeon:
failed to validate.
[ 1459.645540] [drm:radeon_cs_ioctl] *ERROR* Failed to parse relocation !
[ 1461.208487] [drm:drm_mode_getfb] *ERROR* invalid framebuffer id
[ 1461.218685] [drm] LVDS-13: set mode 1024x768 1e

Linux oddysseus 2.6.32-rc8a #7 Tue Dec 1 10:24:42 CET 2009 i686 GNU/Linux
This build is from today with the latest pull till commit
d6fdb37126aa4f67484a9962b68963c5d3a506af.

If more info is needed, I'' try my best so ask for it.

Sincerelly yours
C. Hartmann
-- 
......oooO..............
.....(....).....Oooo...
......)../.....(....)....
.....(_/.......)../.....
...............(_/.......
... I WAS ..............
.......... HERE...... ;)
