Return-Path: <linux-kernel-owner+w=401wt.eu-S1754194AbZAMQPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194AbZAMQPp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 11:15:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752212AbZAMQPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 11:15:33 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40410 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751721AbZAMQPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 11:15:31 -0500
Date: Tue, 13 Jan 2009 16:14:50 +0000
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
Message-ID: <20090113161450.2fdd1d5d@lxorguk.ukuu.org.uk>
In-Reply-To: <496CA26E.1080708@garzik.org>
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
	<20090113140328.3aab5a35@lxorguk.ukuu.org.uk>
	<496CA26E.1080708@garzik.org>
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

> > Now in my experience that is a *dumb* question because the answer is
> > obvious...
> 
> The choice is between "new magic OSD fs" and "new fs that used to be 
> ext4, before we hacked it up".
> 
> "existing one you trust" is not an option...

No it isn't. The choice is existing technology followed by a "thank you
goodbye Mr OSD salesman".

I'm not saying we shouldn't work on an OSD file system and I'm glad IBM
folks are but that it can be done slowly. Also for most fs folks an OSD
emulator testing might not be a bad idea - say one stacked on ext3 8)


