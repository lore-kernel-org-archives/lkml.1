Return-Path: <linux-kernel-owner+w=401wt.eu-S933550AbXBXTyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933550AbXBXTyR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 14:54:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933552AbXBXTyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 14:54:16 -0500
Received: from moutng.kundenserver.de ([212.227.126.188]:56304 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933550AbXBXTyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 14:54:16 -0500
Subject: Re: current git crashes on bootup with pci_iounmap()
From: Kay Sievers <kay.sievers@vrfy.org>
To: Tejun Heo <htejun@gmail.com>
Cc: Marcel Holtmann <marcel@holtmann.org>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <45DC2E52.4030506@gmail.com>
References: <1171380714.3829.6.camel@pim.off.vrfy.org>
	 <1171382645.23580.29.camel@violet>
	 <1171385524.3855.2.camel@pim.off.vrfy.org>
	 <3ae72650702141257w6b30a8efge5b6109feebb5512@mail.gmail.com>
	 <45DC2E52.4030506@gmail.com>
Content-Type: text/plain
Date: Sat, 24 Feb 2007 20:40:15 +0100
Message-Id: <1172346015.3766.1.camel@min.off.vrfy.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:4ddcc9dd12ba6cf3155e4d81b383efda
X-Provags-ID2: V01U2FsdGVkX1/TwukZao3rFxvuM0i9BttVAk+zvN5++oaFEeB25Cqo2x4m26PT4+BLPA9wc9Y+KmLcV6w3R7Die/tEP6kt5OhDDE0ks5NptDVK900XpFDowg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-02-21 at 20:34 +0900, Tejun Heo wrote:
> Kay Sievers wrote:
> > On 2/13/07, Kay Sievers <kay.sievers@vrfy.org> wrote:
> >> On Tue, 2007-02-13 at 17:04 +0100, Marcel Holtmann wrote:
> >> > > kernel BUG at lib/iomap.c:254!
> >> > > invalid opcode: 0000 [#1]
> >> > > ...
> >> > >
> >> > > The screen picture is here:
> >> > >   http://vrfy.org/pci_iounmap.jpg
> >> > >
> >> > > It's a Thinkpad T43p.
> >> > >
> >> > > 2.6.20 was working fine.
> >> > >
> >> > > Commenting out:
> >> > >   IO_COND(addr, /* nothing */, iounmap(addr));
> >> > > in:
> >> > >   lib/iomap.c:254
> >> > > makes at least booting up possible.
> >> >
> >> > I saw a similar one on my X41. Disabling the AHCI driver made the
> >> > machine booting again.
> >>
> >> Hey Marcel,
> >> yeah, that works fine here too.
> > 
> > Tejun, Jeff, any ideas what's going wrong with the iomap change and
> > the AHCI driver?
> 
> The following commit should have fixed the problem, at least the oops.
> Care to give the current git head a shot?

Yes, it boots fine now with the AHCI driver compiled in.

Thanks,
Kay

