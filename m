Return-Path: <linux-kernel-owner+w=401wt.eu-S1754126AbYGGCxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126AbYGGCxP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 22:53:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752310AbYGGCw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 22:52:58 -0400
Received: from mail.gmx.net ([213.165.64.20]:45470 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752135AbYGGCw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 22:52:57 -0400
X-Authenticated: #476490
X-Provags-ID: V01U2FsdGVkX1/l9Bh4HZ3lMHLz/MPS4t4bTIPrMcw6K6RxOZZRuA
	rIo4f2xSJytDTv
From: Oliver Endriss <o.endriss@gmx.de>
Organization: ESCAPE GmbH EDV-Loesungen
To: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] Remove fdump tool for av7110 firmware
Date: Mon, 7 Jul 2008 04:52:00 +0200
User-Agent: KMail/1.9.6
Cc: David Woodhouse <dwmw2@infradead.org>,
       Klaus Schmidinger <Klaus.Schmidinger@cadsoft.de>,
       kernelnewbies <kernelnewbies@nl.linux.org>,
       kernel-janitors <kernel-janitors@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jaswinder Singh <jaswinder@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <1214139259.2994.8.camel@jaswinder.satnam> <48708BBF.9050400@cadsoft.de> <1215343022.10393.945.camel@pmac.infradead.org>
In-Reply-To: <1215343022.10393.945.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807070452.02204@orion.escape-edv.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse wrote:
> On Sun, 2008-07-06 at 11:09 +0200, Klaus Schmidinger wrote:
> > On 07/06/08 03:15, Oliver Endriss wrote:
> > > Jaswinder Singh wrote:
> > >> There's no point in this, since the user can use the BUILTIN_FIRMWARE
> > >> option to include arbitrary firmware files directly in the kernel image.
> > > 
> > > NAK! This option allows to compile the firmware into the _driver_,
> > > which is very useful if you want to test various driver/firmware
> > > combinations. Having the firmware in the _kernel_ does not help!
> > 
> > I strongly support Oliver's request!
> > Working with various driver versions is much easier with the
> > firmware compiled into the driver!
> 
> That's strange; I've found exactly the opposite to be the case. 
> 
> If I want to test permutations of driver and firmware, as I've done for
> the libertas driver a number of times, I find it _much_ better to
> preserve the modularity. I can build each version of the driver and can
> test that against various firmware versions without having to rebuild
> it, and with much less chance of something going wrong so that I'm not
> actually testing what I think I'm testing.
> 
> Perhaps I'm missing something that would help me work better? Please
> could you help me understand how you currently work, and I'll attempt to
> make it easier for you. Can you talk me through an example of a session
> where you had to do this testing of 'various driver/firmware
> combinations'?

Note that the v4ldvb drivers can be configured and compiled outside the
kernel tree. Basically I have several directory trees, for example
- v4l-dvb_head
- v4l-dvb_31dec2007_fw2622
- v4l-dvb_31dec2007_fwf12623
- ...

Within these directories you can simply use "make menuconfig" to
configure the driver. If you compile the firmware into the driver,
you can easily freeze a 'known good' or 'known bad' configuration.

Trying a different driver is as easy as changing directories.
This simplifies testing.

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
----------------------------------------------------------------
