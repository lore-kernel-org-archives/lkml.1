Return-Path: <linux-kernel-owner+w=401wt.eu-S1764296AbXHDPSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764296AbXHDPSe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 11:18:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756508AbXHDPSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 11:18:25 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:55066 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753193AbXHDPSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 11:18:24 -0400
Date: Sat, 4 Aug 2007 16:25:46 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Mike Frysinger" <vapier.adi@gmail.com>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: custom baud rates with serial core
Message-ID: <20070804162546.145d4628@the-village.bc.nu>
In-Reply-To: <8bd0f97a0708031659o1e32722cq99b1c248367d6da6@mail.gmail.com>
References: <8bd0f97a0708031659o1e32722cq99b1c248367d6da6@mail.gmail.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Aug 2007 19:59:51 -0400
"Mike Frysinger" <vapier.adi@gmail.com> wrote:

> is there a method for setting custom baud rates that doesnt cause a
> "deprecated" message from showing up ?  for example:
> # setserial -a /dev/ttyBF0 divisor 9 spd_cust
> setserial sets custom speed on ttyBF0. This is deprecated.

If your platform is up to date then you can set arbitary speeds via the
TIOCGETS2/TIOCSETS2 ioctls. Not all platforms support this yet although
I'm working on getting the sane ones all upstream and sorted. Once that
is done glibc will be able to switch internally to TIOCGETS2/SETS2 for
the termios operations it provides and the world will be a far happier
place ...
