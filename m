Return-Path: <linux-kernel-owner+w=401wt.eu-S1755710AbXKWB2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710AbXKWB2O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 20:28:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752454AbXKWB17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 20:27:59 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:44027 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752362AbXKWB16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 20:27:58 -0500
Date: Fri, 23 Nov 2007 01:25:25 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: niessner@jpl.nasa.gov
Cc: Kyle McMartin <kyle@mcmartin.ca>, linux-kernel@vger.kernel.org
Subject: Re: Where is the interrupt going?
Message-ID: <20071123012525.126010d5@the-village.bc.nu>
In-Reply-To: <20071122164853.cfdplzj5o744sw40@webmail.jpl.nasa.gov>
References: <1195693710.5544.240.camel@morte.jpl.nasa.gov>
	<20071122022004.GB9265@fattire.cabal.ca>
	<20071122164853.cfdplzj5o744sw40@webmail.jpl.nasa.gov>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Nov 2007 16:48:53 -0800
niessner@jpl.nasa.gov wrote:

> 
> I tried the hammer and the problem persists.

See my earlier email - your driver registers the irq with IRQF_DISABLED
then never enables it.
