Return-Path: <linux-kernel-owner+w=401wt.eu-S1752736AbZBNRek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736AbZBNRek (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 12:34:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751568AbZBNRea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 12:34:30 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:54550 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbZBNRea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 12:34:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=GbdSe90IcHIHgcd2YDp4xTGGvbH9+QpC+P00fvb9hub+OgiYOrkrxwzoGT3O/Rbu+3
         vpowr8XA1G998ya76ECQtuAqtP/fvGS0MoV9KPUeFOjvOl3dJZgx+ZyASbRGTVdR5lnI
         P0CjfTHeDeqiIdAgTyRAUtlsabhHdvG/2//Ik=
MIME-Version: 1.0
Date: Sat, 14 Feb 2009 12:34:28 -0500
Message-ID: <47ed01bd0902140934v2b96695cibccb37ed9fd1ec09@mail.gmail.com>
Subject: Can someone update alsa in the kernel?
From: Dylan Taft <d13f00l@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been using alsa compiled outside the kernel for several months,
it broke some time ago around 2.6.27 for my hardware.
alsa-driver-1.0.19 works fine, for snd-hda-intel

With whatever version is in the kernel now, when the modules are
loaded, dmesg fills up with
hda_codec: invalid dep_range_val 0:7fff


alsa driver 1.0.19 will work, but
ALSA /var/tmp/portage/media-sound/alsa-driver-1.0.18a/work/alsa-driver-1.0.18a/pci/hda/../../alsa-kernel/pci/hda/hda_intel.c:623:
hda_intel: azx_get_response timeout, switching to polling mode: last
cmd=0x100f0000
ALSA /var/tmp/portage/media-sound/alsa-driver-1.0.18a/work/alsa-driver-1.0.18a/pci/hda/../../alsa-kernel/pci/hda/hda_intel.c:1258:
hda_intel: Codec #1 probe error; disabling it...
hda_codec: Unknown model for ALC883, trying auto-probe from BIOS...
d13f00l-desktop diefool #

shows in dmesg,it works totally fine though
lspci -k
00:1b.0 Audio device: Intel Corporation Device 3a3e
	Kernel driver in use: HDA Intel
	Kernel modules: snd-hda-intel

If you do a quick google on invalid_dep_range_val, a bunch of bugs
have been filed for various distros, but it's been fixed in later
versions of alsa.  This would save a lot of headaches for newer users
unfamiliar with alsa if it was merged into the kernel.

Any comments?

Thanks!

Dylan
