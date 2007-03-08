Return-Path: <linux-kernel-owner+w=401wt.eu-S1751884AbXCHOQO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884AbXCHOQO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 09:16:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751904AbXCHOQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 09:16:14 -0500
Received: from mail.gmx.net ([213.165.64.20]:33352 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751879AbXCHOQN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 09:16:13 -0500
X-Authenticated: #31060655
X-Provags-ID: V01U2FsdGVkX1/bXtYpxpbb8pkCfB/v1B83HZUrt6w/HkBsdDDlB7
	MuhcTnezJxSCOk
Message-ID: <45F01AA8.7010608@gmx.net>
Date: Thu, 08 Mar 2007 15:16:08 +0100
From: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.9) Gecko/20060911 SUSE/1.0.7-0.1 SeaMonkey/1.0.7
MIME-Version: 1.0
To: Robin Getz <rgetz@blackfin.uclinux.org>, Oleksiy Kebkal <kebkal@gmail.com>,
       Krzysztof Halasa <khc@pm.waw.pl>, Mike Frysinger <vapier.adi@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-serial@vger.kernel.org
Subject: Re: should RTS init in serial core be tied to CRTSCTS
References: <8bd0f97a0703011603m794e00f5x875eb68ad0db05de@mail.gmail.com> <200703071019.55896.rgetz@blackfin.uclinux.org> <57354eff0703071330k2395e9c8n58e12f2111dcb25a@mail.gmail.com> <200703080844.32157.rgetz@blackfin.uclinux.org> <20070308134800.GA30023@flint.arm.linux.org.uk>
In-Reply-To: <20070308134800.GA30023@flint.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 08.03.2007 14:48, Russell King wrote:
> As I've said already, having a console on the same port as your application
> program is just asking for trouble.  All bets are off - the kernel _will_
> corrupt your data stream in random places.
> 
> Don't do it - it will _NEVER_ be reliable.
> 
> Never, ever, mix kernel consoles with application serial ports.

Unless you want two machines to monitor each other via serial console and
each of them has only one serial port. It's not perfect, but it works well
enough despite all claims to the contrary.

Regards,
Carl-Daniel
