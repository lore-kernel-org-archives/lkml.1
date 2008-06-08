Return-Path: <linux-kernel-owner+w=401wt.eu-S1757106AbYFHVDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757106AbYFHVDX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 17:03:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754384AbYFHVDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 17:03:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43097 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754778AbYFHVDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 17:03:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.26-rc5-git2: snd-emu10k1 does not work
Date: Sun, 8 Jun 2008 23:03:58 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Takashi Iwai <tiwai@suse.de>, Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806082303.59245.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

snd-emu10k1 doesn't work on one of my test boxes.  The driver apparently loads,
but the card is not visible, for example, to any mixer apps (including the ALSA
mixer).  However, YaST correctly detects and reports the card (the system is
openSUSE 10.3, x86-64).  The openSUSE-made kernel (2.6.22-something) does
correctly work on the same hardware.

Is there anything I should pay attention to, like any options related to /proc
or sysfs that could have an effect on the audio adapter?

Thanks,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
