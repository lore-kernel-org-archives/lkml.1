Return-Path: <linux-kernel-owner+w=401wt.eu-S1755507AbYEQNWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507AbYEQNWU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 09:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753302AbYEQNWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 09:22:11 -0400
Received: from fmailhost01.isp.att.net ([204.127.217.101]:57800 "EHLO
	fmailhost01.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251AbYEQNWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 09:22:10 -0400
X-Originating-IP: [70.152.106.225]
Date: Sat, 17 May 2008 08:22:07 -0500
From: Jay Cliburn <jacliburn@bellsouth.net>
To: Chris Rankin <rankincj@yahoo.com>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: 2.6.25.3: serial problem (minicom)
Message-ID: <20080517082207.4b1e8556@osprey.hogchain.net>
In-Reply-To: <762763.57234.qm@web52903.mail.re2.yahoo.com>
References: <20080516123321.5674952c@osprey.hogchain.net>
	<762763.57234.qm@web52903.mail.re2.yahoo.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 May 2008 13:29:31 +0100 (BST)
Chris Rankin <rankincj@yahoo.com> wrote:

> --- Jay Cliburn <jacliburn@bellsouth.net> wrote:
> > Serial console using minicom works fine for me under 2.6.25 and
> > 2.6.25.4.  Keystrokes are accepted normally.
> 
> I have just replicated this problem between two Fedora 8 boxes;
> minicom reads the remote serial console fine, provided it is running
> on a 2.6.24.x kernel. (The serial console is from a 2.6.25.4 machine.)
> 
> My serial console is defined using the kernel parameters
> "console=ttyS0,115200n8", and my minicom session as:
> 
> pr port             /dev/ttyS1
> pu baudrate         115200
> pu bits             8
> pu parity           N
> pu stopbits         1
> #pu minit            ^M

Mine still works.  I was going to bisect it, but I don't encounter the
problem.

[jcliburn@sparrow ~]$ uname -a
Linux sparrow 2.6.25.4 #1 SMP Fri May 16 11:31:19 CDT 2008 i686 i686 i386 GNU/Linux

[jcliburn@sparrow ~]$ cat /etc/fedora-release 
Fedora release 8 (Werewolf)

[jcliburn@sparrow ~]$ cat /etc/minirc.dfl 
# Machine-generated file - use "minicom -s" to change parameters.
pu port             /dev/ttyS0
pu baudrate         38400
pu bits             8
pu parity           N
pu stopbits         1

jcliburn@sparrow ~]$ grep CONFIG_SERIAL linux-2.6.25.y.git/.config
CONFIG_SERIAL_NONSTANDARD=y
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CS=m
CONFIG_SERIAL_8250_NR_UARTS=32
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
# CONFIG_SERIAL_8250_FOURPORT is not set
# CONFIG_SERIAL_8250_ACCENT is not set
# CONFIG_SERIAL_8250_BOCA is not set
# CONFIG_SERIAL_8250_EXAR_ST16C554 is not set
# CONFIG_SERIAL_8250_HUB6 is not set
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250_DETECT_IRQ=y
CONFIG_SERIAL_8250_RSA=y
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=m

