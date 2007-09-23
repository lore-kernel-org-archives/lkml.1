Return-Path: <linux-kernel-owner+w=401wt.eu-S1757288AbXIWKoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288AbXIWKoR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 06:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754262AbXIWKoD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 06:44:03 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47969 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932AbXIWKoB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 06:44:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: 2.6.23-rc4-mm1 and -rc6-mm1: boot failure on HP nx6325, related to clockevents
Date: Sun, 23 Sep 2007 12:57:11 +0200
User-Agent: KMail/1.9.5
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709231257.12213.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

Unfortunately, my observation that the patch series:

http://tglx.de/projects/hrtimers/2.6.23-rc4/patch-2.6.23-rc4-hrt1.patches.tar.bz2

worked with 2.6.23-rc4 was wrong.  It _sometimes_ works, but usually doesn't
boot, just like 2.6.23-rc4-mm1, 2.6.23-rc6-mm1 and everything in between with
the above patch series applied.  I've also tried:

http://tglx.de/projects/hrtimers/2.6.23-rc5/patch-2.6.23-rc5-hrt1.patches.tar.bz2
http://tglx.de/projects/hrtimers/2.6.23-rc6/patch-2.6.23-rc6-hrt2.patch

with the same result.

The problematic patch is x86_64-convert-to-clockevents.patch .

Since the boot fails very early, before any messages reach the (VGA) console,
I have no idea what to do next, except for digging in the code.

Greetings,
Rafael
