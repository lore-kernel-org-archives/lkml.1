Return-Path: <linux-kernel-owner+w=401wt.eu-S939942AbXG3WWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939942AbXG3WWc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 18:22:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968220AbXG3WWE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 18:22:04 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:49447 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S939569AbXG3WWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 18:22:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=SeI27cGUA0AySU5XgjiYgh7/gdJ5Yh8tAbrjV8hPN/kMzOvN4pkPMoaxu8hWxK1CbfMxv7+P1oX0ZTBRu03QfT5kARG8Jh4DRz4JsnIh4/Wm+GOG926UgqTYYb4qU3ix76xbMp8AQ+cqawJ+bl7BwprKoosJkyfbkdhK1YCxZ4I=
Message-ID: <3ae72650707301522r4241353ld1be5dd7a2322233@mail.gmail.com>
Date: Tue, 31 Jul 2007 00:22:01 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Sasa Ostrouska" <casaxa@gmail.com>
Subject: Re: forcedeth ?
Cc: "Gabriel C" <nix.or.die@googlemail.com>,
       "Avuton Olrich" <avuton@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <dcf706c60707301510n6c2b649p447396fc042c25e5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dcf706c60707301301j21d3cf60n59a686c9abb5e5b3@mail.gmail.com>
	 <3aa654a40707301337w52bbe246o99db15b9f8e7a2c4@mail.gmail.com>
	 <dcf706c60707301426q4858d039hdfa49fb26835d367@mail.gmail.com>
	 <46AE6029.60308@googlemail.com>
	 <dcf706c60707301510n6c2b649p447396fc042c25e5@mail.gmail.com>
X-Google-Sender-Auth: 7bedb6c9b145684d
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/31/07, Sasa Ostrouska <casaxa@gmail.com> wrote:
> On 7/31/07, Gabriel C <nix.or.die@googlemail.com> wrote:
> > Sasa Ostrouska wrote:
> > > On 7/30/07, Avuton Olrich <avuton@gmail.com> wrote:
> > >> On 7/30/07, Sasa Ostrouska <casaxa@gmail.com> wrote:
> > >>> Hi people,
> > >>>
> > >>> I'm using this on a x86-64 amd machine. During boot of the last
> > >>> 2.6.22.1 kernel I get this error:
> > >> Somewhat unrelated, but I had a similar forcedeth problem, I took the
> > >> latest git forcedeth.c and put it into 2.6.22.1 and it worked for me.
> > >>
> > >> Good luck!
> > >> --
> > >> avuton
> > >
> > > Ok, maybe I can try that. In any case I noticed another strange thing.
> > > I have 2 nics in that machine.
> > > One is a nvidia MPC61 using the forcedeth.c the other one is a Realtec
> > > RTL8029 using the
> > > ne2k_pci.
> > > Now, whenever I compile them both as modules each reboot the cards get
> > > inversed eth assignement. Suppose first boot, the forcedeth is eth0 ,
> > > the next boot it is eth1 , this is very anoying as one cant make only
> > > one boot, probably this is someway related to the bios.
> > > Now I configured them one in the kernel and the other as a module so
> > > they get each time assigned the same name. But when powerloss happens
> > > (unplug the cable) the next boot they do not work. I see them assigned
> > > the correct name, ifconfig shows the IP's but ping results in a
> > > destination unreachable.
> > >
> > > Any ideas ?
> >
> > Udev rules ?
> >
> Gabriel, hmm, shouldnt udev be able to autoconfigure that ? But I need
> to check that, thx for the tip.

Udev does that already, it automatically creates rules and assigns
persistent names to newly discovered network hardware. The names will
be stable across reboots, regardless of module loading order or
anything else. But sure, that's only on distros who take these issues
serious. :)

Kay
