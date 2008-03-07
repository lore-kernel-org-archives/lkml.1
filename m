Return-Path: <linux-kernel-owner+w=401wt.eu-S1760183AbYCGW4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760183AbYCGW4d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 17:56:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754196AbYCGW4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 17:56:22 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:37552 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753936AbYCGW4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 17:56:21 -0500
Date: Fri, 7 Mar 2008 22:43:35 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Elias Oltmanns <eo@nebensachen.de>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC] Disk shock protection (revisited)
Message-ID: <20080307224335.0412d8a2@core>
In-Reply-To: <87bq5qfm2v.fsf@denkblock.local>
References: <87skzgd1zk.fsf@denkblock.local>
	<20080226123946.75dbe3d2@core>
	<87mypl8p49.fsf@denkblock.local>
	<20080228111349.6831925c@core>
	<87bq5qfm2v.fsf@denkblock.local>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This business of aborting commands is exactly what I haven't a clue
> about. At first I thought I could do something similar to
> ata_do_link_abort but I obviously want to avoid the need for a soft
> reset before issuing idle immediate. How am I to go about it?

See the ATA 7 specification, and then stare at libata, and then stress a
lot and realise it is going to be very hard.

Seriously - get the queue freezing stuff working first and then I'm sure
one of us libata folk who actually have the misfortune to read these
specs regularly will add in the details like that.

