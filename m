Return-Path: <linux-kernel-owner+w=401wt.eu-S1760243AbZAMOE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760243AbZAMOE3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 09:04:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758958AbZAMOEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 09:04:10 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60055 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752799AbZAMOEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 09:04:07 -0500
Date: Tue, 13 Jan 2009 14:03:28 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Boaz Harrosh <bharrosh@panasas.com>, Matthew Wilcox <matthew@wil.cx>,
       Benny Halevy <bhalevy@panasas.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, Avishay Traeger <avishay@gmail.com>,
       open-osd development <osd-dev@open-osd.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 7/9] exofs: mkexofs
Message-ID: <20090113140328.3aab5a35@lxorguk.ukuu.org.uk>
In-Reply-To: <496C9ABE.8060300@garzik.org>
References: <4947BFAA.4030208@panasas.com>
	<4947CA5C.50104@panasas.com>
	<20081229121423.efde9d06.akpm@linux-foundation.org>
	<495B8D90.1090004@panasas.com>
	<1230739053.3408.74.camel@localhost.localdomain>
	<4960D3CA.2000202@panasas.com>
	<1231783926.3256.29.camel@localhost.localdomain>
	<496B989F.7050907@garzik.org>
	<1231790190.15161.29.camel@localhost.localdomain>
	<496BA671.3070900@garzik.org>
	<1231802758.27151.18.camel@localhost.localdomain>
	<496C9ABE.8060300@garzik.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It seems unlikely drive manufacturers would get excited about a 
> sub-optimal solution that does not even approach using the full 
> potential of the product.

You forgot the more important people

Mr Customer, would you like your data centre to use a new magic OSD fs or
the existing one you trust.

Now in my experience that is a *dumb* question because the answer is
obvious...

> Plus, given the existence of an OSD-specific filesystem (exofs, at the 
> very least), it seems unlikely that end users who own OSDs would choose 
> the sub-optimal solution when an OSD-specific filesystem exists.

Actually until you can show zillions of users stably using them the
people with the money won't buy them in the first place 8)

> > ready for the consumer market until 2011.  That's not really going to
> > convince the disk vendors that OSD based devices should be marketed
> > today.
> 
> And you have a similar sales job and lag time, when hacking -- read 
> destabilizing -- a filesystem to work with OSDs as well as sector-based 
> devices.

2011 sounds optimistic for major OSD adoption in any space except for
flash storage where OSD type knowledge means you can do much better jobs
on erase management.

