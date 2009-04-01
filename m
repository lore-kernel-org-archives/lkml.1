Return-Path: <linux-kernel-owner+w=401wt.eu-S1761250AbZDARN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761250AbZDARN1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 13:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754410AbZDARNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 13:13:16 -0400
Received: from outbound-mail-02.bluehost.com ([69.89.21.12]:41937 "HELO
	outbound-mail-02.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753590AbZDARNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 13:13:15 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=JDfOmJTHQJVgLyhoisNfbIrSlP6u+m7C8iY94ImXDlA8tpE0A3N1aMmUStSowSymZi0xv3ry5qZ/783Ur0tN3m4PxbyHbs6DjkPRos2l1gmSpuC5B9YMEiNvLF3upv4I;
Date: Wed, 1 Apr 2009 10:13:09 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [git pull] PCI changes for 2.6.30
Message-ID: <20090401101309.67d0bea5@hobbes>
In-Reply-To: <alpine.LFD.2.00.0904010957520.4130@localhost.localdomain>
References: <20090331121331.3673cf59@hobbes>
	<alpine.LFD.2.00.0904010957520.4130@localhost.localdomain>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Apr 2009 10:01:12 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Tue, 31 Mar 2009, Jesse Barnes wrote:
> >
> > Please consider pulling my PCI tree from
> >   git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6
> > linux-next
> 
> This produces
> 
>   WARNING: drivers/built-in.o(.text+0x69a1): Section mismatch in
> reference from the function dev_rescan_store() to the
> function .devinit.text:pci_rescan_bus() The function
> dev_rescan_store() references the function __devinit
> pci_rescan_bus(). This is often because dev_rescan_store lacks a
> __devinit annotation or the annotation of pci_rescan_bus is wrong.
> 
> Hmm?

Arg how did I miss that?  Maybe the last build I did was missing
hotplug support or something... Anyway looking now (at first glance I
think pci_rescan_bus needs to drop __devinit).

> > Anyway hope this pull is ok.  I went through every warning by hand
> > to make sure none were caused by PCI commits, but that was with the
> > bits in this tree, which are -rc8 vintage.
> 
> You can tell it's rebased, but at least it's not rebased five minutes
> ago, so I assume it has some testing. It's the "I just rebased a
> couple of minutes before posting this 'please pull' message" that I
> find really annoying, since it's so clear that the end result has no
> real testing at all.

Yeah, this tree generally sees a good amount of testing, especially
from the hotplug folks.  And yeah, I'd never rebase and then do a pull
request; I like to let things sit in linux-next for at least a day to
flush out any build errors and give a chance for people to test any
merge conflicts I resolved.

-- 
Jesse Barnes, Intel Open Source Technology Center
