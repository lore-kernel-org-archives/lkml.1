Return-Path: <linux-kernel-owner+w=401wt.eu-S1752483AbXA2J2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483AbXA2J2h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 04:28:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752429AbXA2J2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 04:28:37 -0500
Received: from mail.first.fraunhofer.de ([194.95.169.2]:59587 "EHLO
	mail.first.fraunhofer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932671AbXA2J2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 04:28:20 -0500
Subject: 2.6.20-rc6 appletouch: incomplete data package (first byte: 2,
	length: 4).
From: Soeren Sonnenburg <kernel@nn7.de>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sat, 27 Jan 2007 16:04:36 +0100
Message-Id: <1169910276.2462.62.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

I realized that when I compile/load ehci-hcd as a module on this
macbookpro1,1 that appletouch would stop functioning and send tons of

appletouch: incomplete data package (first byte: 2, length: 4).
appletouch: incomplete data package (first byte: 2, length: 4).
appletouch: incomplete data package (first byte: 2, length: 4).
appletouch: incomplete data package (first byte: 2, length: 4).
appletouch: incomplete data package (first byte: 2, length: 4).
appletouch: incomplete data package (first byte: 2, length: 4).
appletouch: incomplete data package (first byte: 2, length: 4).
appletouch: incomplete data package (first byte: 2, length: 4).
appletouch: incomplete data package (first byte: 2, length: 4).

*UNTIL* I rmmod appletouch and modprobe appletouch again:

usbcore: deregistering interface driver appletouch
appletouch Geyser 3 inited.
input: appletouch as /class/input/input12
usbcore: registered new interface driver appletouch
appletouch: incomplete data package (first byte: 2, length: 4).

After that it is working.

Soeren
-- 
Sometimes, there's a moment as you're waking, when you become aware of
the real world around you, but you're still dreaming.
