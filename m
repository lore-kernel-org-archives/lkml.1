Return-Path: <linux-kernel-owner+w=401wt.eu-S1756175Ab0A1NyN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175Ab0A1NyN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 08:54:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756031Ab0A1NyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 08:54:11 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36158 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755114Ab0A1NyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 08:54:10 -0500
Date: Thu, 28 Jan 2010 14:54:05 +0100
From: Andi Kleen <andi@firstfloor.org>
To: dmitry.torokhov@gmail.com, linux-kernel@vger.kernel.org
Subject: PNP PS/2 probing racy?
Message-ID: <20100128135405.GA28931@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I noticed that on one test system of machine when booting the same
kernel I get:

PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12

and sometimes on another boot

PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12

Since I presume the BIOS does not change, is it possible the Linux
procedure for this PNP probe is racy? I haven't checked the code so far.

Full boot logs for both cases:

http://halobates.de/config/dmesg-pnprace-1
http://halobates.de/config/dmesg-pnprace-2

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
