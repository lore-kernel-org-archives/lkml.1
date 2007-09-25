Return-Path: <linux-kernel-owner+w=401wt.eu-S1753978AbXIYLyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978AbXIYLyq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 07:54:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752162AbXIYLyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 07:54:39 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34120 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751992AbXIYLyj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 07:54:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: 2.6.23-rc8-mm1, -rc7-mm1 kill audio on HP nx6325
Date: Tue, 25 Sep 2007 14:08:53 +0200
User-Agent: KMail/1.9.5
Cc: Andi Kleen <ak@suse.de>, Takashi Iwai <tiwai@suse.de>,
       LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709251408.54361.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch from Andi:

x86_64-mm-cpa-einval.patch

makes the hda_intel audio driver stop working on my HP nx6325.

The following line appears in dmesg (from 2.6.23-rc7-mm1:

ALSA /home/rafael/src/mm/linux-2.6.23-rc7-mm1/sound/pci/hda/hda_intel.c:1755: hd
a-intel: ioremap error

and the driver doesn't work afterwards.

Still, I'm not sure if the patch above is wrong or rather it exposes a problem
in the driver.

Greetings,
Rafael
