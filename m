Return-Path: <linux-kernel-owner+w=401wt.eu-S1751421AbXBOAjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751421AbXBOAjY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 19:39:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751420AbXBOAjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 19:39:24 -0500
Received: from smtpout14-02.prod.mesa1.secureserver.net ([68.178.232.8]:59002
	"HELO smtpout14-02.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751421AbXBOAjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 19:39:23 -0500
Date: Wed, 14 Feb 2007 17:39:22 -0700
From: akennedy@techmoninc.com
Subject: RE: Serial console issues.
To: Alan <alan@lxorguk.ukuu.org.uk>
cc: linux-kernel@vger.kernel.org
Message-ID: <20070214173922.bfc52cea95091b0fffcb409eab6296ba.d67be632a9.wbe@email.secureserver.net>
MIME-Version: 1.0
Content-Type: TEXT/plain; CHARSET=US-ASCII
User-Agent: Web-Based Email 4.9.14
X-Originating-IP: 68.209.83.41
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > In a previous post I incorrectly stated that my serial port is a
> > TI16750, as this is what /proc/tty/... revealed to me.  After
> > re-reading the product manual, I see that this is actually a 16550.
> > Since Linux is seeing this port as a 16750, could that explain why I'm
> > seeing missing characters in the transmission.  After doing some
> > research, I found that the 16750 has a 64-byte buffer, whereas I know
> > this to only have a 16-byte buffer.
>
> The autodetect is pretty solid so you may well find the chip is 16750
> compatible, 16550A is what is usually listed because it is what people
> look for.
>
> > If my assumptions are correct and Linux is detecting this serial port
> > incorrectly, how can I force the serial driver to see this a 16550?
>
> man setserial

Well, this is the most bastardized sucker I've ever seen. . . I have had
no end of trouble with it (couldn't even get a boot loader to work with
it - had to write my own).  And, as luck would have it, the serial port
is no different.  Using setserial, I changed the type of this port to a
16550A and all my problems went away.  The question now remains:  How
can I FORCE the Linux serial driver to see this as a 16550A -- As I
before stated, I know that this has a 16-byte buffer.  Therefore, the
16750 with its mammoth buffer size is killing this serial port.  Short
of modifying the kernel (which I'd rather not do) or including the
setserial with the kernel image (also I'd rather not do as I only have
2.3 MB of storage on this device) I need a command line parameter to
control the serial line -- is there one?  A build option?  PLEASE
SOMETHING???

Andy

