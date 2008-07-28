Return-Path: <linux-kernel-owner+w=401wt.eu-S1755809AbYG1LPP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755809AbYG1LPP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 07:15:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753472AbYG1LPB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 07:15:01 -0400
Received: from mx1.suse.de ([195.135.220.2]:47676 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750728AbYG1LPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 07:15:00 -0400
Date: Mon, 28 Jul 2008 13:14:58 +0200
From: Karsten Keil <kkeil@suse.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: benh@kernel.crashing.org, David Miller <davem@davemloft.net>,
       sfr@canb.auug.org.au, kkeil@suse.de, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: mISDN still breaking the allmodconfig build...
Message-ID: <20080728111458.GA26604@pingi.kke.suse.de>
References: <20080727.170235.97056809.davem@davemloft.net> <1217204022.11188.139.camel@pasglop> <20080727204805.59f55dda@lappy.seanm.ca> <20080728102009.5fb3df6b@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080728102009.5fb3df6b@lxorguk.ukuu.org.uk>
Organization: SuSE Linux AG
X-Operating-System: Linux 2.6.16.54-0.2.5-smp x86_64
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2008 at 10:20:09AM +0100, Alan Cox wrote:
> On Sun, 27 Jul 2008 20:48:05 -0400
> Sean MacLennan <smaclennan@pikatech.com> wrote:
> 
> > On Mon, 28 Jul 2008 10:13:42 +1000
> > "Benjamin Herrenschmidt" <benh@kernel.crashing.org> wrote:
> > 
> > > On Sun, 2008-07-27 at 17:02 -0700, David Miller wrote:
> > > > More fallout from the premature mISDN driver merge:
> > > > 
> > > > drivers/isdn/hardware/mISDN/hfcmulti.c:5255:2: error: #error "not
> > > > running on big endian machines now"
> > > 
> > > Lovely...
> > 
> > mISDN is notoriously bad on big endian machines.
> 

This only affect the hardware IO layer of some cards and I think
it will be fixed very soon, I did not remove the very old
#error line, because I did not had the hardware to verify that it is
OK now.
I already reserved a PPC machine now (will get it today or tomorrow) and
will test the endian robustness this week.

> In which case it really should not be in Linus tree but in linux-next.
> Karsten - will you ask Linus to revert mISDN so it can go into linux-next
> instead and get cleaned up in the right place ?
> 

This was my original plan and my fault, that I only included the
pull URL and sent it to Linus diectely, I did not know that in this case
Linus will pull it without further discussion, but I'm still glad that it
is in and only show few issues (I'm very unhappy that I did not find
these before, I did builds on all our architectures, but not with the
all*config, only with subsets).
The good thing is, that this brought back the ENDIAN issue back on my
radar and on my near time TODO list :-)

-- 
Karsten Keil
SuSE Labs
ISDN and VOIP development
SUSE LINUX Products GmbH, Maxfeldstr.5 90409 Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
