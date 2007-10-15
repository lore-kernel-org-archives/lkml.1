Return-Path: <linux-kernel-owner+w=401wt.eu-S1764980AbXJON0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764980AbXJON0o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 09:26:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761330AbXJON0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 09:26:34 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:42742 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757871AbXJON0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 09:26:33 -0400
Date: Mon, 15 Oct 2007 14:29:45 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Theodore Tso <tytso@mit.edu>
Cc: Rob Landley <rob@landley.net>,
       James Bottomley <James.Bottomley@steeleye.com>,
       Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Nick Piggin <piggin@cyberone.com.au>
Subject: Re: What still uses the block layer?
Message-ID: <20071015142945.2cb27911@the-village.bc.nu>
In-Reply-To: <20071015132106.GE21216@thunk.org>
References: <200710112011.22000.rob@landley.net>
	<200710141845.44750.rob@landley.net>
	<20071015014503.GF9715@thunk.org>
	<200710150304.00901.rob@landley.net>
	<20071015132106.GE21216@thunk.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> You can pull a Model and Serial number via hdparm -i, but it's not as
> easy to manipulate as a fixed-length MAC address.  That's why people
> tend to use filesystem UUID's.   

ATA8 at the moment looks set to add a true "MAC" or "WWN" type identifier
to each device.. Right now model/serial is not always unique.

