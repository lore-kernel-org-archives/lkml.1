Return-Path: <linux-kernel-owner+w=401wt.eu-S933085AbXCHTNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933085AbXCHTNT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 14:13:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933084AbXCHTNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 14:13:19 -0500
Received: from smtp22.msg.oleane.net ([62.161.4.22]:34695 "EHLO
	smtp22.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933079AbXCHTNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 14:13:18 -0500
X-Greylist: delayed 1778 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Mar 2007 14:13:17 EST
From: "Tosoni" <jp.tosoni@acksys.fr>
To: "'Krzysztof Halasa'" <khc@pm.waw.pl>,
       "'Carl-Daniel Hailfinger'" <c-d.hailfinger.devel.2006@gmx.net>
Cc: "'Robin Getz'" <rgetz@blackfin.uclinux.org>,
       "'Oleksiy Kebkal'" <kebkal@gmail.com>,
       "'Mike Frysinger'" <vapier.adi@gmail.com>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
       <linux-serial@vger.kernel.org>
Subject: RE: should RTS init in serial core be tied to CRTSCTS
Date: Thu, 8 Mar 2007 19:43:15 +0100
Message-ID: <000201c761b1$a281cdf0$2e01a8c0@acksys.local>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook CWS, Build 9.0.2416 (9.0.2910.0)
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Importance: Normal
In-Reply-To: <m3r6rz3chb.fsf@maximus.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa wrote:

> OTOH I wonder what does the device in question require WRT the
> serial port and WRT RTS line in particular.
> I know there are some half-duplex converters which drive RTS only
> while sending and which require CTS to send.

As far as I know in the old times this was the *standard* way to use a modem
(per CCITT V24), and even nowadays many modems can handle this method for
transmit, to stay compatible with the standard.

Think of radio modems. Some are inherently half duplex.

> They are perhaps a bit broken <snip>
No, no, they apply an old standard. Probably they are old as well.
>
> I don't know if one can expect RTS to stay low all the time. Even
> a simple /sbin/setserial from /etc/rc.* would drive it high for
> a moment. I'm afraid the only way which makes sense may be using
> a customized plug.

It's a pity that Linux (or Unixes) never handled RTS this way.
I feel that the /proc or sysfs solutions are the best to alter this well
established default in this driver. It would not break existing installed
hardware.

