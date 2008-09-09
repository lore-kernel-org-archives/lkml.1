Return-Path: <linux-kernel-owner+w=401wt.eu-S1754410AbYIIEjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410AbYIIEjZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 00:39:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751520AbYIIEjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 00:39:17 -0400
Received: from outbound-mail-115.bluehost.com ([69.89.24.5]:58301 "HELO
	outbound-mail-115.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751020AbYIIEjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 00:39:16 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=qWCcw6WWMGQSOjVp8GktUis20GuLceBzG/AdkrYzZgV061e/4y56XxifnVsjs24hYAJFyJSHwuLpOFYJosrLgDH+pqsj44JKOlomC4/pYgTQrZTxykPTFNEoJOXtYZwV;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: linux-next: Tree for September 3
Date: Mon, 8 Sep 2008 21:39:03 -0700
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>
References: <20080903191619.6b6b230e.sfr@canb.auug.org.au> <20080904012544.cabed847.akpm@linux-foundation.org> <alpine.LFD.1.10.0809040143350.3452@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0809040143350.3452@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809082139.03714.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 12.108.5.2 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 04, 2008 1:50 am Linus Torvalds wrote:
> On Thu, 4 Sep 2008, Andrew Morton wrote:
> > <plugs it in>
> >
> > cs: pcmcia_socket0: unable to apply power.
> > pccard: CardBus card inserted into slot 0
> > pci 0000:07:00.0: supports D1
> > pci 0000:07:00.0: supports D2
> > pci 0000:07:00.0: PME# supported from D1 D2 D3hot D3cold
> > pci 0000:07:00.0: PME# disabled
> >
> > sony:/home/akpm> lspci -s07:00
> > 07:00.0 Ethernet controller: 3Com Corporation 3cCFE575CT CardBus
> > [Cyclone] (rev 10)
>
> Ok, the PCI resource side definitely works.
>
> I've committed the fix as follows.. (the explanation is about three times
> the size, but whatever ;)
>
> As to that "unable to apply power" thing, that's a separate issue.. And
> in fact one that probably doesn't even matter to a CardBus card, since
> cardbus doesn't care about the insane CS state machines anyway.
>
> Anyway, Ivan and Jesse cc'd for the patch, but I committed it, since I
> was involved in causing the bug in the first place.

Yeah, looks reasonable.  Thanks for pushing it already; I've had crappy to 
non-existent network access for the past week...

Thanks,
Jesse
