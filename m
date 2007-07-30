Return-Path: <linux-kernel-owner+w=401wt.eu-S969675AbXG3Waq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969675AbXG3Waq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 18:30:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968993AbXG3WaB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 18:30:01 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:64042 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S940111AbXG3W37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 18:29:59 -0400
Subject: Re: forcedeth ?
From: Kay Sievers <kay.sievers@vrfy.org>
To: david@lang.hm
Cc: Sasa Ostrouska <casaxa@gmail.com>, Gabriel C <nix.or.die@googlemail.com>,
       Avuton Olrich <avuton@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0707301522340.12232@asgard.lang.hm>
References: <dcf706c60707301301j21d3cf60n59a686c9abb5e5b3@mail.gmail.com>
	 <3aa654a40707301337w52bbe246o99db15b9f8e7a2c4@mail.gmail.com>
	 <dcf706c60707301426q4858d039hdfa49fb26835d367@mail.gmail.com>
	 <46AE6029.60308@googlemail.com>
	 <dcf706c60707301510n6c2b649p447396fc042c25e5@mail.gmail.com>
	 <3ae72650707301522r4241353ld1be5dd7a2322233@mail.gmail.com>
	 <Pine.LNX.4.64.0707301522340.12232@asgard.lang.hm>
Content-Type: text/plain
Date: Tue, 31 Jul 2007 00:32:31 +0200
Message-Id: <1185834751.1911.57.camel@lov.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.5 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+lmwS8bSSNVF1BCwtiBbsfNf/rhe13edsZ3rF
 8IuYpJQjo6npCmn5/iT6gTG+n4vlP/FBF72baaH6EEDqZWg/li
 pCcLyENEJpVOhWRrjme1yQiP+wgR+Nl
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2007-07-30 at 15:24 -0700, david@lang.hm wrote:
> On Tue, 31 Jul 2007, Kay Sievers wrote:
> 
> > On 7/31/07, Sasa Ostrouska <casaxa@gmail.com> wrote:
> >> On 7/31/07, Gabriel C <nix.or.die@googlemail.com> wrote:
> >>> Sasa Ostrouska wrote:
> >>>> On 7/30/07, Avuton Olrich <avuton@gmail.com> wrote:
> >>>>> On 7/30/07, Sasa Ostrouska <casaxa@gmail.com> wrote:
> >>>>>> Hi people,
> >>>>>>
> >>>>>> I'm using this on a x86-64 amd machine. During boot of the last
> >>>>>> 2.6.22.1 kernel I get this error:
> >>>>> Somewhat unrelated, but I had a similar forcedeth problem, I took the
> >>>>> latest git forcedeth.c and put it into 2.6.22.1 and it worked for me.
> >>>>>
> >>>>> Good luck!
> >>>>> --
> >>>>> avuton
> >>>>
> >>>> Ok, maybe I can try that. In any case I noticed another strange thing.
> >>>> I have 2 nics in that machine.
> >>>> One is a nvidia MPC61 using the forcedeth.c the other one is a Realtec
> >>>> RTL8029 using the
> >>>> ne2k_pci.
> >>>> Now, whenever I compile them both as modules each reboot the cards get
> >>>> inversed eth assignement. Suppose first boot, the forcedeth is eth0 ,
> >>>> the next boot it is eth1 , this is very anoying as one cant make only
> >>>> one boot, probably this is someway related to the bios.
> >>>> Now I configured them one in the kernel and the other as a module so
> >>>> they get each time assigned the same name. But when powerloss happens
> >>>> (unplug the cable) the next boot they do not work. I see them assigned
> >>>> the correct name, ifconfig shows the IP's but ping results in a
> >>>> destination unreachable.
> >>>>
> >>>> Any ideas ?
> >>>
> >>> Udev rules ?
> >>>
> >> Gabriel, hmm, shouldnt udev be able to autoconfigure that ? But I need
> >> to check that, thx for the tip.
> >
> > Udev does that already, it automatically creates rules and assigns
> > persistent names to newly discovered network hardware. The names will
> > be stable across reboots, regardless of module loading order or
> > anything else. But sure, that's only on distros who take these issues
> > serious. :)
> 
> what do I need to do to disable this 'feature' having a box with 
> interfaces eth0, eth9, eth10 becouse the box once had a couple of quad 
> cards in it is annoying.

Edit the created rules file and change the entries to the names you
like. 

If you don't like the renaming at all, remove the rules files that
maintain the persistent rules file. But then you have the same problem
if some hardware, or probing order changes.

Kay

