Return-Path: <linux-kernel-owner+w=401wt.eu-S1756230AbYHDNZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230AbYHDNZl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 09:25:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753550AbYHDNZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 09:25:31 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60718 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753594AbYHDNZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 09:25:30 -0400
Date: Mon, 4 Aug 2008 14:07:44 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>
Subject: Re: Kernel Summit request for Discussion of future of ATA (libata)
 and IDE
Message-ID: <20080804140744.7f2da5f6@lxorguk.ukuu.org.uk>
In-Reply-To: <F29B8321-272A-45B4-9D72-DC6A9EB407F1@kernel.crashing.org>
References: <1217779055.4179.10.camel@localhost.localdomain>
	<20080803173941.314edf33@lxorguk.ukuu.org.uk>
	<F29B8321-272A-45B4-9D72-DC6A9EB407F1@kernel.crashing.org>
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

On Mon, 4 Aug 2008 08:16:47 -0500
Kumar Gala <galak@kernel.crashing.org> wrote:

> 
> On Aug 3, 2008, at 11:39 AM, Alan Cox wrote:
> 
> > - For certain embedded PPC boards there are some things to sort out  
> > with
> > IRQ routing on non standards sane configurations using pata_ali in
> > particular.
> 
> Alan, do you have any specifics here?

Some people are running PPC setups which report the IDE controller as in
native mode, the PCI IRQ as zero and in fact are using legacy IRQ lines.
