Return-Path: <linux-kernel-owner+w=401wt.eu-S1754139AbYBQPtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139AbYBQPtQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 10:49:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750987AbYBQPtB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 10:49:01 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:46332 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750978AbYBQPtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 10:49:00 -0500
Date: Sun, 17 Feb 2008 15:40:36 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Smith <asmith@tranquility.fsbusiness.co.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: Corruption problems in pata_via for Via NanoBook
 owners (Cloudbook, EasyNote XS etc.)
Message-ID: <20080217154036.185bb11a@core>
In-Reply-To: <5BDDEEF9-D2AC-4112-83EB-43D02E8C4E6C@tranquility.fsbusiness.co.uk>
References: <5BDDEEF9-D2AC-4112-83EB-43D02E8C4E6C@tranquility.fsbusiness.co.uk>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In 2.24 the device ID 0x581 for Vendor VIA was added to the pata_via  
> driver causing some problems.

Actually we've had the CX700 supported for a while and as Tejun has
fixed other bugs related to it we know its being used and tested. The
slave port is a bit quirky but that is purely in the way it seems to mess
up the snooping of mode changes. Yours is the first bug report of this
type so more information about the precise combination of devices used
and the actual logs would be useful.

> It builds fine and seems to start up OK, however, on large IOs then  
> the kernel starts to throw errors about MULTICMDs (I think that was  
> the term) returning an invalid response.

No thats not a term I can guess at - do you have any logs with the exact
error reports in them ?

Also unfortunately you've compared 2.6.23 with 2.6.24 which means a bug
anywhere else could be causing the behaviour you see. It would be very
interesting to know if 2.6.24 built with old IDE rather than pata_via
(which is just config options) shows a difference in behaviour on your
box.

Alan
