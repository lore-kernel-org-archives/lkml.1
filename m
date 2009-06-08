Return-Path: <linux-kernel-owner+w=401wt.eu-S1754247AbZFHRtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247AbZFHRtc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 13:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750975AbZFHRtY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 13:49:24 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:49761 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750758AbZFHRtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 13:49:23 -0400
Subject: Re: 2.6.30-rc8 Oops whilst booting
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chris Clayton <chris2553@googlemail.com>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org,
       scsi <linux-scsi@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>
In-Reply-To: <alpine.LFD.2.01.0906081039520.6847@localhost.localdomain>
References: <200906061959.55592.chris2553@googlemail.com>
	 <200906062215.30571.chris2553@googlemail.com>
	 <1244381140.30664.12.camel@ht.satnam>
	 <c6b1100b0906071138g2c46fb34vc1a2beb9438f1f1e@mail.gmail.com>
	 <1244413881.18742.31.camel@ht.satnam>
	 <2f9e3044bafcae848f74a1492b0ea471.squirrel@neil.brown.name>
	 <c6b1100b0906080108y191bb157n67ec681ade2a0d13@mail.gmail.com>
	 <c6b1100b0906080358y4033c402ra236eff3f972d169@mail.gmail.com>
	 <1244460875.12644.2.camel@ht.satnam>
	 <c6b1100b0906080553o2aa77a40pe0077b1b10a7d88a@mail.gmail.com>
	 <alpine.LFD.2.01.0906080916130.6847@localhost.localdomain>
	 <1244480796.4079.301.camel@mulgrave.site>
	 <alpine.LFD.2.01.0906081039520.6847@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 08 Jun 2009 12:49:22 -0500
Message-Id: <1244483362.4079.358.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-08 at 10:42 -0700, Linus Torvalds wrote:
> 
> On Mon, 8 Jun 2009, James Bottomley wrote:
> > 
> > I think it's a bug in the async code.  It's providing cookies too high
> > because it doesn't stop after it finds a running entry.
> > 
> > Can we try this as the fix?
> 
> Ok, this looks likely.
> 
> That said, why doesn't that function look like this?

That's probably a better style ... or simply put an if ... else if to
make it exclusive.

James


