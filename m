Return-Path: <linux-kernel-owner+w=401wt.eu-S1754525AbZI3NjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525AbZI3NjS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 09:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754480AbZI3NjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 09:39:17 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:39766 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754337AbZI3NjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 09:39:17 -0400
Message-ID: <4AC35F86.20405@msgid.tls.msk.ru>
Date: Wed, 30 Sep 2009 17:39:18 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: suspend vs usb and PS/2 ports
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I've several PCs here which are able to wakeup -
among others - from PS/2 and/or USB keyboard.
Here for testing I'm using PS/2 keyboard and
Asus M3A78-EM motherboard.

When I do poweroff from linux, the keyboard
stays powered up as it should (according to
the BIOS settings).  But when I do suspend,
keyboard is NOT powered anymore, and hence
the system can't be woken up from it but only
by using the power button.

This happens consistently for many kernel
versions.  To be fair, I don't even know if
there was any kernel which does not show this
behaviour: old versions was unable to do
suspend/resume cycle on this platform at all.

Any hints for this please?

Thanks!

/mjt
