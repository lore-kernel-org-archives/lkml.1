Return-Path: <linux-kernel-owner+w=401wt.eu-S1758583AbYHCTem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758583AbYHCTem (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 15:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752851AbYHCTee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 15:34:34 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58341 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752597AbYHCTee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 15:34:34 -0400
Date: Sun, 3 Aug 2008 20:17:19 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>
Subject: Re: Kernel Summit request for Discussion of future of ATA (libata)
 and IDE
Message-ID: <20080803201719.576f85f6@lxorguk.ukuu.org.uk>
In-Reply-To: <1217791284.4179.34.camel@localhost.localdomain>
References: <1217779055.4179.10.camel@localhost.localdomain>
	<20080803173941.314edf33@lxorguk.ukuu.org.uk>
	<1217783433.4179.18.camel@localhost.localdomain>
	<20080803194501.24fa3e51@lxorguk.ukuu.org.uk>
	<1217791284.4179.34.camel@localhost.localdomain>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I don't envisage anything in terms of code changes (or removal) coming
> out of this.  What I would like is a nice roadmap of where to start for
> people contemplating writing IDE drivers.

For the vendors I've talked with the answer is usually "both". A libata
driver for the future and current distributions, and an old IDE driver
for older RHEL and SLES releases. Fortunately the driver specific parts
for those that are capable of running under old IDE are not too hard to
plug into libata.

Alan
