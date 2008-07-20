Return-Path: <linux-kernel-owner+w=401wt.eu-S1757845AbYGTPLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757845AbYGTPLR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 11:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754250AbYGTPLF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 11:11:05 -0400
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3917 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364AbYGTPLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 11:11:04 -0400
X-Greylist: delayed 642 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Jul 2008 11:11:04 EDT
Message-ID: <48835302.1090708@xs4all.nl>
Date: Sun, 20 Jul 2008 17:00:18 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: kernel: TD structure error TDindex=e
X-Enigmail-Version: 0.95.2
OpenPGP: id=8300CC02
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

In the logs I found a message:

16:41:09 recorder kernel: TD structure error TDindex=e

This was on a VIA EN12000 board (with VIA Velocity Gbit ethernet,
running 2.6.25.7) while doing a file transfer. The card was `down` after
that.
After ifconfig eth0 down, ifconfig eth0 up the device was functional
again but the system froze at a new file transfer attempt.

How can I avoid/fix/etc this situation?

Kind regards,
Udo

