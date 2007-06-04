Return-Path: <linux-kernel-owner+w=401wt.eu-S1757240AbXFDPMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757240AbXFDPMR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 11:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752794AbXFDPMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 11:12:05 -0400
Received: from allen.werkleitz.de ([80.190.251.108]:57301 "EHLO
	allen.werkleitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755306AbXFDPMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 11:12:03 -0400
Date: Mon, 4 Jun 2007 17:11:54 +0200
From: Johannes Stezenbach <js@linuxtv.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Andi Kleen <ak@suse.de>,
       Jiri Kosina <jikos@jikos.cz>,
       kernel list <linux-kernel@vger.kernel.org>
Message-ID: <20070604151154.GA25493@linuxtv.org>
References: <20070604112426.GA2707@elf.ucw.cz> <20070604130903.GC1971@elf.ucw.cz> <Pine.LNX.4.64.0706041511010.29896@twin.jikos.cz> <200706041543.49071.ak@suse.de> <20070604135427.GA19466@elf.ucw.cz> <d120d5000706040702q3b5251e8oc5e9f3c198f060bd@mail.gmail.com> <20070604141345.GB2059@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070604141345.GB2059@elf.ucw.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: 84.190.135.130
Subject: Re: thinkpad testers wanted (was Re: 2.6.22-rc[23]: blinking capslock led, stuck keys?)
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on allen.werkleitz.de)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2007, Pavel Machek wrote:
> 
> > >> Hmm, in theory it could be triggering bugs in some buggy keyboard
> > >> controller. But then a
> > >>
> > >> while true ; do setleds +caps +numlock ; sleep 1 ; setleds -caps -numlock ; sleep 1 ; done
> > >>
> > >> should trigger it too.
> > >
> > >...and it does.
> > >
> > >pavel@amd:~$ while true; do setleds +num; setleds -num; done
> > >Hm,m so thiis  iis  a teest of fkeyboarad behaviour  under lloadd.
> > >
> > >pavel@amd:~$
> > >
> > >...but I'm not quite sure it is a buggy keyboard. It happens _way_ too
> > >often. Launch the line above and try to do some typing...
> > 
> > This used to work fine on my box last time I tried it (the switch
> > itself is offloaded to a keventd and shoud not get in the way) but
> > then they push all kind of ACPI/SMM crap together with KBC so who
> > knows... I should try it again when I get home.
> 
> Hmm, this needs to be ran from console (not X). Can someone with
> thinkpad try this?

I see the same thing with a 2.6.21 kernel on a T42p.


HTH,
Johannes
