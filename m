Return-Path: <linux-kernel-owner+w=401wt.eu-S1763368AbXFJUyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763368AbXFJUyQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 16:54:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756331AbXFJUyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 16:54:05 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:54380 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756236AbXFJUyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 16:54:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OKmv9wARKQYT2sAXJXt61SPbz57j8fBp9f1M3vum1ILG/izb8U0XneMcanLbARsTYb88gm6zCavgmDn8gkBgLqT0i+Vi9JeNeXVuXGYBjri0JrRSnIY6hKR6gCyrvBmhA2sYiDYW02sVeEf6Ksiicdk7BYDOE0Cbe5e7oDVnk8E=
Message-ID: <68676e00706101354n5fe7e1a9y12cb690cae2924e3@mail.gmail.com>
Date: Sun, 10 Jun 2007 22:54:02 +0200
From: Luca <kronos.it@gmail.com>
To: "Avi Kivity" <avi@qumranet.com>
Subject: Re: [kvm-devel] [BUG] Oops with KVM-27
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <466BED18.5040708@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070603213432.GA3075@dreamland.darkstar.lan>
	 <4663DCE9.3000107@qumranet.com>
	 <20070604202248.GA18668@dreamland.darkstar.lan>
	 <46647B3E.2090205@qumranet.com>
	 <20070604212207.GA22365@dreamland.darkstar.lan>
	 <46651069.5040003@qumranet.com>
	 <68676e00706071216i4bd051c5hb1c114f3c13ab97f@mail.gmail.com>
	 <466BED18.5040708@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/10/07, Avi Kivity <avi@qumranet.com> wrote:
> Luca wrote:
> > On 6/5/07, Avi Kivity <avi@qumranet.com> wrote:
> >> Luca Tettamanti wrote:
> >> > Il Mon, Jun 04, 2007 at 11:51:10PM +0300, Avi Kivity ha scritto:
> >> >
> >> >>> While doing repeated tests with the installer I ran into another
> >> >>> (unrelated) problem. Sometimes the guest kernel hangs at boot at:
> >> >>>
> >> >>> NET: Registered protocol family 2
> >> >>>
> >> >>> with any kind of networking options (except for -net none, which
> >> works).
> >> >>> With -no-kvm it boots with any networking option.
> >> >>>
> >> >>>
> >> >>>
> >> >> Can you try to pin the guest on a single core with taskset:
> >> >>
> >> >>    taskset 1 qemu ...
> >> >>
> >> >
> >> > Doesn't help. What works is 'nolapic', i.e. disabling the local
> >> APIC on
> >> > the guest kernel.
> >> > I've also tried disabling TSC (notsc) and forcing PIT as the
> >> clocksource
> >> > (clocksouce=pit clock=pit); neither of them helped.
> >> >
> >> >
> >>
> >> Is this a regression relative to a previous kvm version?
> >
> > Hello,
> > sorry for the delay, I was having troubles compiling older KVMs with a
> > recent kernel...
> > The last version that works is kvm-21; starting from kvm-22 the VM
> > hangs during network initialization (now always, but pretty often).
> > This only occurs when the guest is Fedora7 setup ISO. The regular boot
> > (i.e. from the hd) seems unaffected.
>
> I've managed to reproduce this on kvm-21 (it takes many boots for this
> to happen, but it does eventually).

Hum, any clue on the cause? Should I test older versions?

Luca
