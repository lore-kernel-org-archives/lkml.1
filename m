Return-Path: <linux-kernel-owner+w=401wt.eu-S1756171AbZAJWxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171AbZAJWxv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 17:53:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751778AbZAJWxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 17:53:41 -0500
Received: from one.firstfloor.org ([213.235.205.2]:38189 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbZAJWxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 17:53:40 -0500
To: Hans de Bruin <bruinjm@xs4all.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Kernelmessage to usbstick?
From: Andi Kleen <andi@firstfloor.org>
References: <4968F346.8060806@xs4all.nl>
Date: Sat, 10 Jan 2009 23:53:15 +0100
In-Reply-To: <4968F346.8060806@xs4all.nl> (Hans de Bruin's message of "Sat, 10 Jan 2009 20:13:10 +0100")
Message-ID: <873afqhixw.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hans de Bruin <bruinjm@xs4all.nl> writes:

> Would it be possible to send kernel messages to an usbstick? On
> poweroff my laptop displays a kernel trace and a final message:
> poweroff[3114] exited with preempt_count 2
> /etc/rc.d/rc.0: line 265: 3114 Segementation fault /sbin/poweroff.
> I don't have a serial cable within reach, but plenty of usbsticks.

There's a mtdoops.c indeed, but it currently only works on
MTD controlled flash devices, not usb sticks.

However usb sticks would need the USB subsystem to be running and it's
unlikely that will be the case really late in poweroff.  So it might
not help.

-Andi

-- 
ak@linux.intel.com
