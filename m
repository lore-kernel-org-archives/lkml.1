Return-Path: <linux-kernel-owner+w=401wt.eu-S1753456AbZFEKlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456AbZFEKlz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 06:41:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751636AbZFEKlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 06:41:47 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55603 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750999AbZFEKlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 06:41:46 -0400
Date: Fri, 5 Jun 2009 11:42:45 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Grozdan <neutrino8@gmail.com>
Cc: hancockrwd@gmail.com, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: Kernel 2.6.30rc7 limits IDE to UDMA33
Message-ID: <20090605114245.175499e1@lxorguk.ukuu.org.uk>
In-Reply-To: <c5bd819b0906050335i4e813887sc8f4d901da86a1aa@mail.gmail.com>
References: <c5bd819b0906021525l13ee9282j1fb270e141985f66@mail.gmail.com>
	<4A25F688.9000407@gmail.com>
	<c5bd819b0906030435w466368cbsd48be91a97597437@mail.gmail.com>
	<20090603131407.57c490ed@lxorguk.ukuu.org.uk>
	<c5bd819b0906030552w6f23185etb394f83c8b630e6@mail.gmail.com>
	<20090603140140.491a8ea8@lxorguk.ukuu.org.uk>
	<c5bd819b0906030639o5f9c34ffg500e132d3a0b5117@mail.gmail.com>
	<c5bd819b0906040750w75e0389cod2a03b89ce838d1b@mail.gmail.com>
	<20090605100505.41b3b818@lxorguk.ukuu.org.uk>
	<c5bd819b0906050335i4e813887sc8f4d901da86a1aa@mail.gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I've relayed your reply to the pata_amd user on the forum. As for my
> case with pata_via, until this is fixed, is there any way to force it
> to use a higher UDMA? Is there a flag that can be passed in, for

In your case given the BIOS appears to be informing us you have a 40wire
cable there isn't much that can be fixed

> example, in /sys somewhere? hdparm fails to set a higher UDMA and I
> looked at sdparm but don't see anything in it to increase UDMA...

Tejun some time ago added stuff to override all of these things:

See Documentation/kernel-parameters.txt

	libata.force=

which will let you override all sorts of autodetection for quirky boards
