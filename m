Return-Path: <linux-kernel-owner+w=401wt.eu-S1758554AbXJOV7G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758554AbXJOV7G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 17:59:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759024AbXJOV6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 17:58:38 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:51149 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757002AbXJOV6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 17:58:36 -0400
Date: Mon, 15 Oct 2007 23:01:37 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rob Landley <rob@landley.net>
Cc: Neil Brown <neilb@suse.de>, Theodore Tso <tytso@mit.edu>,
       James Bottomley <James.Bottomley@steeleye.com>,
       Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Nick Piggin <piggin@cyberone.com.au>
Subject: Re: What still uses the block layer?
Message-ID: <20071015230137.3cdbeb71@the-village.bc.nu>
In-Reply-To: <200710151634.57407.rob@landley.net>
References: <200710112011.22000.rob@landley.net>
	<200710150304.00901.rob@landley.net>
	<18195.19678.500863.613193@notabene.brown>
	<200710151634.57407.rob@landley.net>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> This is where we disagree.  The existence of devices you cannot stably 
> enumerate does not eliminate the existence of devices you trivially can.

"trivially" 

You are I assume familiar in full with EDD 3.0, EDD 1.x and the Ralf
Brown documentation on the BIOS drive mappings and tables for different
BIOSes ?

If you are then you could add EDD 1.x spport, FADT parsing and update the
EDD driver to produce links to the drives in BIOS map order. Would be
quite useful but very few people on the planet actually know all the
arcana to do this.

Alan
