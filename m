Return-Path: <linux-kernel-owner+w=401wt.eu-S1752700AbYFLEPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700AbYFLEPq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 00:15:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750802AbYFLEPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 00:15:36 -0400
Received: from smtps.uol.com.br ([200.221.4.131]:42986 "EHLO smtp.uol.com.br"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750794AbYFLEPf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 00:15:35 -0400
Date: Thu, 12 Jun 2008 01:15:30 -0300
From: =?iso-8859-1?Q?Rog=E9rio?= Brito <rbrito@ime.usp.br>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, linux-kernel@vger.kernel.org,
       rbrito@ime.usp.br
Subject: Re: [2.6.26-rc4] Problems with rt2x00 USB interface on powerpc
Message-ID: <20080612041530.GA19980@ime.usp.br>
References: <20080601193000.GA3056@ime.usp.br> <200806081242.54896.IvDoorn@gmail.com> <20080608213513.GA30499@ime.usp.br> <200806090002.17938.IvDoorn@gmail.com> <20080609001540.GA19072@ime.usp.br> <20080611093605.GA13557@ime.usp.br> <20080611134323.GA7149@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080611134323.GA7149@tuxdriver.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SIG5: b3ef07dee8442ec3539d7bff0ab3d83f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Ivo and John.

On Jun 11 2008, John W. Linville wrote:
> On Wed, Jun 11, 2008 at 06:36:05AM -0300, Rogério Brito wrote:
> > I don't know if you received my earlier message.
> > 
> > On Jun 08 2008, Rogério Brito wrote:
> > > Correction here: I just went to the ia32 notebook again and, now,
> > > running Ubuntu's hardy kernel (which is a patched 2.6.24 kernel,
> > > AFAIK---yes, it is; just checked it) I could make the D-Link stick
> > > work fine.
> > 
> > The only problem that I had is that I had to reissue the command
> > "iwconfig wlan0 ap any" or, otherwise, the connection with the AP
> > would be dropped (I can get a log for you to peruse, if you wish).

Let me be a bit more detailed here: when I connected the D-Link stick on
the ia32 notebook with Ubuntu's 2.6.24 kernel, if I *didn't* issue the
command "iwconfig wlan0 ap any" *periodically* (say, with
     # while true; iwconfig wlan0 ap any; sleep 10; done
), then the connection would die: the dmesg logs would indicate that the
AP lost connection with the stick.

By the way, I see this exactly same behaviour with the rt61pci driver on
the same machine (with the only difference being that the interface name
is ra0 instead of wlan0): I even put a cron job to issue the command
every minute, so that my parents (which are using a PCMCIA card that
uses the rt61pci) don't have to learn about the nasty things of
networking.

Anyway, I would be happy to get the D-Link USB stick getting a lease
from the AP as a first step. This way, I think that I could help you
both much more than what I can now, and I would be a step closer into
the direction of ditching MacOS X.

> What does "iwconfig wlan0" show _before_ doing the "iwconfig wlan0 ap any"?

Actually, it shows the output that I listed before in the mail that had
the script "levanta.sh" attached (which was blocked by many people's
e-mail servers): both interfaces up and configured with the same AP (but
the ra0 one with the DHCP daemon disabled).

(In that message, I mentioned something along the lines: notice that the
Signal Strength is reported to be higher on the ra0 interface than on
the wlan0, despite both working on ia32).


Regards, Rogério Brito.

P.S.: Sorry for an e-mail not more detailed. I'm not with physical
access to my parent's notebook.
-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org
