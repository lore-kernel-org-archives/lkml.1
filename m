Return-Path: <linux-kernel-owner+w=401wt.eu-S1756502AbXHBK0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756502AbXHBK0y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 06:26:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755975AbXHBK0o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 06:26:44 -0400
Received: from hobbit.corpit.ru ([81.13.94.6]:22791 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755387AbXHBK0m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 06:26:42 -0400
Message-ID: <46B1B160.8090906@msgid.tls.msk.ru>
Date: Thu, 02 Aug 2007 14:26:40 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
User-Agent: Icedove 1.5.0.12 (X11/20070607)
MIME-Version: 1.0
To: Herbert Rosmanith <kernel@wildsau.enemy.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: VIA EPIA EK: strange eth dev numbering
References: <200708021020.l72AKvjC008561@wildsau.enemy.org>
In-Reply-To: <200708021020.l72AKvjC008561@wildsau.enemy.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Rosmanith wrote:
> hi,

Hello.

[]
> When doing the module load, the kernel says:
>     eth0: VIA Rhine III at 0x1d000, 00:40:63:ee:96:56, IRQ 17.
>     eth0: MII PHY found at address 1, status 0x7869 advertising 05e1 Link 45e1.
>     eth1: VIA Rhine II at 0x1ec00, 00:40:63:ee:96:55, IRQ 18.
>     eth1: MII PHY found at address 1, status 0x7849 advertising 05e1 Link 0000.
[]
> it took a while until, just out of a feeling in my stomach, I tried "ifconfig -a",
> and surprise, surprise, the ethernet devices were in fact there, *but* there
> names where eth2 and eth3.
[]
> pretty strange?! I dont think this is the correct behaviour, is it?

Strange or not, correct or not - depends on the point of view.

The key word here is "udev" - check your udev rules.  Since some time
ago udev on some distros comes with rules to give persistent device
names for network interfaces.  Some time ago you had eth0 and eth1
with different hardware, and udev remembered this fact somewhere.
Now it sees new hardware, and gives it consecutive numbers, renaming
kernel devices.

/mjt
