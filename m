Return-Path: <linux-kernel-owner+w=401wt.eu-S1754545AbYG1Jim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545AbYG1Jim (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 05:38:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751987AbYG1Jie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 05:38:34 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36874 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750827AbYG1Jid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 05:38:33 -0400
Date: Mon, 28 Jul 2008 10:20:09 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sean MacLennan <smaclennan@pikatech.com>
Cc: <benh@kernel.crashing.org>, "David Miller" <davem@davemloft.net>,
       <sfr@canb.auug.org.au>, <kkeil@suse.de>, <linux-kernel@vger.kernel.org>,
       <linuxppc-dev@ozlabs.org>, <akpm@linux-foundation.org>,
       <torvalds@linux-foundation.org>
Subject: Re: mISDN still breaking the allmodconfig build...
Message-ID: <20080728102009.5fb3df6b@lxorguk.ukuu.org.uk>
In-Reply-To: <20080727204805.59f55dda@lappy.seanm.ca>
References: <20080727.170235.97056809.davem@davemloft.net>
	<1217204022.11188.139.camel@pasglop>
	<20080727204805.59f55dda@lappy.seanm.ca>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Jul 2008 20:48:05 -0400
Sean MacLennan <smaclennan@pikatech.com> wrote:

> On Mon, 28 Jul 2008 10:13:42 +1000
> "Benjamin Herrenschmidt" <benh@kernel.crashing.org> wrote:
> 
> > On Sun, 2008-07-27 at 17:02 -0700, David Miller wrote:
> > > More fallout from the premature mISDN driver merge:
> > > 
> > > drivers/isdn/hardware/mISDN/hfcmulti.c:5255:2: error: #error "not
> > > running on big endian machines now"
> > 
> > Lovely...
> 
> mISDN is notoriously bad on big endian machines.

In which case it really should not be in Linus tree but in linux-next.
Karsten - will you ask Linus to revert mISDN so it can go into linux-next
instead and get cleaned up in the right place ?

Alan
