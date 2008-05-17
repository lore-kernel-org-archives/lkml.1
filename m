Return-Path: <linux-kernel-owner+w=401wt.eu-S1757158AbYEQOtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757158AbYEQOtT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 10:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752631AbYEQOtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 10:49:11 -0400
Received: from web52902.mail.re2.yahoo.com ([206.190.49.12]:23909 "HELO
	web52902.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752160AbYEQOtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 10:49:10 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=lGlQ/H2cZR51+d3Q6h6rNEe2pswmFhTIxJf2WtrRx4tQt0cakbVOCjvz91kxJDolGn25t/0XYZBrDeDz2upqZ/tShEXGOyjr1Pd0iABawpHaDPQFtump7gr65UDghX9CDxNnSRL/Hkk4dmwv8+u0Jyo6iFdSMAwLB528ylsEnFo=;
X-YMail-OSG: ..OcT_YVM1nuTk8uxtGarEcwCn3V_8T0APj5BNv_g5mxotQ6kF.U.w.v4TcvX.n.6ADBLHvlfDvd1wT.RNUV7ooQeJgRmkmX0LK.s_dUAZdRwZiDZnDzYDUZ1g--
Date: Sat, 17 May 2008 15:49:08 +0100 (BST)
From: Chris Rankin <rankincj@yahoo.com>
Subject: Re: 2.6.25.3: serial problem (minicom)
To: Jay Cliburn <jacliburn@bellsouth.net>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
In-Reply-To: <20080517082207.4b1e8556@osprey.hogchain.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <543631.10570.qm@web52902.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- Jay Cliburn <jacliburn@bellsouth.net> wrote:
> Mine still works.  I was going to bisect it, but I don't encounter the
> problem.
> 
> [jcliburn@sparrow ~]$ uname -a
> Linux sparrow 2.6.25.4 #1 SMP Fri May 16 11:31:19 CDT 2008 i686 i686 i386 GNU/Linux
> 
> [jcliburn@sparrow ~]$ cat /etc/fedora-release 
> Fedora release 8 (Werewolf)
> 
> [jcliburn@sparrow ~]$ cat /etc/minirc.dfl 
> # Machine-generated file - use "minicom -s" to change parameters.
> pu port             /dev/ttyS0
> pu baudrate         38400
> pu bits             8
> pu parity           N
> pu stopbits         1
> 
> jcliburn@sparrow ~]$ grep CONFIG_SERIAL linux-2.6.25.y.git/.config
> CONFIG_SERIAL_NONSTANDARD=y
> CONFIG_SERIAL_8250=y
> CONFIG_SERIAL_8250_CONSOLE=y
> CONFIG_SERIAL_8250_PCI=y
> CONFIG_SERIAL_8250_PNP=y
> CONFIG_SERIAL_8250_CS=m
> CONFIG_SERIAL_8250_NR_UARTS=32
> CONFIG_SERIAL_8250_RUNTIME_UARTS=4
> CONFIG_SERIAL_8250_EXTENDED=y
> CONFIG_SERIAL_8250_MANY_PORTS=y
> # CONFIG_SERIAL_8250_FOURPORT is not set
> # CONFIG_SERIAL_8250_ACCENT is not set
> # CONFIG_SERIAL_8250_BOCA is not set
> # CONFIG_SERIAL_8250_EXAR_ST16C554 is not set
> # CONFIG_SERIAL_8250_HUB6 is not set
> CONFIG_SERIAL_8250_SHARE_IRQ=y
> CONFIG_SERIAL_8250_DETECT_IRQ=y
> CONFIG_SERIAL_8250_RSA=y
> CONFIG_SERIAL_CORE=y
> CONFIG_SERIAL_CORE_CONSOLE=y
> CONFIG_SERIAL_JSM=m

Does yours still work if you raise the baud rate to 115200? Here's my .config for 2.6.25.x, which
is unchanged since 2.6.24.x:

# CONFIG_SERIAL_NONSTANDARD is not set
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
# CONFIG_SERIAL_8250_MANY_PORTS is not set
CONFIG_SERIAL_8250_SHARE_IRQ=y
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
# CONFIG_SERIAL_8250_RSA is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set

Cheers,
Chris



      __________________________________________________________
Sent from Yahoo! Mail.
A Smarter Email http://uk.docs.yahoo.com/nowyoucan.html
