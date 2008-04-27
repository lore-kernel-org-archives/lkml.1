Return-Path: <linux-kernel-owner+w=401wt.eu-S1758631AbYD0QdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758631AbYD0QdU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 12:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753811AbYD0QdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 12:33:09 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:43563 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648AbYD0QdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 12:33:09 -0400
Message-ID: <4814AAD7.9010306@larces.uece.br>
Date: Sun, 27 Apr 2008 13:33:27 -0300
From: Sergio Luis <sergio@larces.uece.br>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Bart Van Assche <bart.vanassche@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25 slow boot/reboot
References: <48141111.7010605@larces.uece.br> <e2e108260804270823t45611ec2t35da085833d82dfa@mail.gmail.com>
In-Reply-To: <e2e108260804270823t45611ec2t35da085833d82dfa@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bart Van Assche wrote:
> On Sun, Apr 27, 2008 at 7:37 AM, Sergio Luis <sergio@larces.uece.br> wrote:
>>  This weekend I got some time and decided to try out 2.6.25, but its booting process was _really_ slow in my laptop[1]. With 'old' 2.6.24.5 my machine would take about 48 secs until it gave me the login prompt. And it would take about 22 seconds to reboot.
> 
> Do you use LILO or GRUB for booting ? 2.6.25 works OK on the systems I
> tested, but LILO really needs a lot of time to load the 2.6.25 kernel.
> GRUB loads the 2.6.25 kernel at normal speed.

I use LILO, but read your answer and tested GRUB, and you are right, GRUB starts the boot process much faster than LILO, but I was talking about the time it takes once the kernel is booting already. Isn't that independent from the bootloader used?

I experience the same problems when I use GRUB.
For instance, I see
"Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled"
and the system seems to freeze for a while. It takes about 90 seconds for the next message (floppy0: no floppy controllers found) to show up.

-sergio
