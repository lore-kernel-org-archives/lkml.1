Return-Path: <linux-kernel-owner+w=401wt.eu-S1755340AbXFDOCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340AbXFDOCm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 10:02:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752031AbXFDOCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 10:02:35 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:11207 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036AbXFDOCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 10:02:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DCN2AeAY+Jw7+N0/4FwJeICVFNCkzlh124+rmPjhdUylG3McBfPNW8ObzWqlbdyLvCev6UVDyNmZqw556/aq2smo5IpNJbE3Zg0ktgP2B0xRa675L4fzk700oYFmw7WxUAMZ4LL57HEfzCVpf3filxB4yEZpNI7bRFBScEmceRQ=
Message-ID: <d120d5000706040702q3b5251e8oc5e9f3c198f060bd@mail.gmail.com>
Date: Mon, 4 Jun 2007 10:02:33 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: 2.6.22-rc[23]: blinking capslock led, stuck keys?
Cc: "Andi Kleen" <ak@suse.de>, "Jiri Kosina" <jikos@jikos.cz>,
       "kernel list" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070604135427.GA19466@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070604112426.GA2707@elf.ucw.cz>
	 <20070604130903.GC1971@elf.ucw.cz>
	 <Pine.LNX.4.64.0706041511010.29896@twin.jikos.cz>
	 <200706041543.49071.ak@suse.de> <20070604135427.GA19466@elf.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/4/07, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
> > > Are you sure that it's this dummy blink driver that makes the kernel
> > > stuck? I can't see how it could be causing any hogs - see commit f038f9.
> > >
> > > Anyway, added Andi to CC.
> >
> > Hmm, in theory it could be triggering bugs in some buggy keyboard
> > controller. But then a
> >
> > while true ; do setleds +caps +numlock ; sleep 1 ; setleds -caps -numlock ;
> > sleep 1 ; done
> >
> > should trigger it too.
>
> ...and it does.
>
> pavel@amd:~$ while true; do setleds +num; setleds -num; done
> Hm,m so thiis  iis  a teest of fkeyboarad behaviour  under lloadd.
>
> pavel@amd:~$
>
> ...but I'm not quite sure it is a buggy keyboard. It happens _way_ too
> often. Launch the line above and try to do some typing...

This used to work fine on my box last time I tried it (the switch
itself is offloaded to a keventd and shoud not get in the way) but
then they push all kind of ACPI/SMM crap together with KBC so who
knows... I should try it again when I get home.

-- 
Dmitry
