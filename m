Return-Path: <linux-kernel-owner+w=401wt.eu-S1755692AbYKOKe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755692AbYKOKe2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 05:34:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754004AbYKOKeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 05:34:17 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51702 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753918AbYKOKeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 05:34:15 -0500
Date: Sat, 15 Nov 2008 10:34:24 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Robert Hancock <hancockr@shaw.ca>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-raid@vger.kernel.org
Subject: Re: 2.6.27.6 question: ata_sff_hsm_move: ata15 (why always ata15)?
Message-ID: <20081115103424.34f01370@lxorguk.ukuu.org.uk>
In-Reply-To: <491E4092.5030804@shaw.ca>
References: <alpine.DEB.1.10.0811141850590.6217@p34.internal.lan>
	<491E4092.5030804@shaw.ca>
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

On Fri, 14 Nov 2008 21:22:58 -0600
Robert Hancock <hancockr@shaw.ca> wrote:

> Justin Piszcz wrote:
> > I am trying to find out what the root cause of this error/problem is:
> > https://bugzilla.redhat.com/show_bug.cgi?id=462425
> 
> The problem is that people assume that timeouts with DRDY like that bug 
> refers to must be the same problem when it is often not

The first stopping point is to apply the DRQ drain patch I sent to the
list some time ago and is hopefully lined up for 2.6.29. After that point
you can begin to look at the remaining cases, until then its hardly worth
it.

Alan

