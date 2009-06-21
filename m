Return-Path: <linux-kernel-owner+w=401wt.eu-S1755578AbZFUW5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578AbZFUW5m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 18:57:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753424AbZFUW5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 18:57:34 -0400
Received: from gate.crashing.org ([63.228.1.57]:46915 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753261AbZFUW5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 18:57:33 -0400
Subject: Re: Badness on the Warp
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Sean MacLennan <smaclennan@pikatech.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Frans Pop <elendil@planet.nl>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       David Gibson <david@gibson.dropbear.id.au>,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <20090621183658.2b408e69@lappy.seanm.ca>
References: <20090620154824.72b5cd50@lappy.seanm.ca>
	 <200906202256.46073.elendil@planet.nl>
	 <20090620194250.5a3e826f@lappy.seanm.ca>
	 <200906210628.35553.elendil@planet.nl>
	 <84144f020906210320n2984807dw2d4b4fb38afd22cf@mail.gmail.com>
	 <1245623104.16880.26.camel@pasglop>
	 <20090621183658.2b408e69@lappy.seanm.ca>
Content-Type: text/plain
Date: Mon, 22 Jun 2009 08:57:15 +1000
Message-Id: <1245625035.16880.31.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-06-21 at 18:36 -0400, Sean MacLennan wrote:
> On Mon, 22 Jun 2009 08:25:04 +1000
> Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> 
> > Right, our interrupt controllers need those fixes, they are low
> > on my priority list since it's a reasonably harmless warning and I'm
> > still chasing some actual breakage (though maybe not directly related
> > to your patches).
> > 
> > Kumar already submitted a couple, Frans, feel free to beat me
> > at converting UIC (just use kmalloc directly in there instead
> > of alloc_bootmem).
> 
> I can make the changes to UIC if you want. They badness is harmless (it
> ends up calling kzalloc anyway), but hard to explain to our PV (Product
> Verification) department that they can ignore what looks like a crash ;)

Heh, right, but hopefully we should have that fixed before .31 is
out :-)

Cheers,
Ben.


