Return-Path: <linux-kernel-owner+w=401wt.eu-S1758059AbYGGTDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758059AbYGGTDs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 15:03:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757649AbYGGTDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 15:03:36 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48840 "EHLO
	the-village.bc.nu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757461AbYGGTDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 15:03:35 -0400
Date: Mon, 7 Jul 2008 19:30:08 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: David Woodhouse <dwmw2@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       David Miller <davem@davemloft.net>, tytso@mit.edu, hugh@veritas.com,
       akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
       mchan@broadcom.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       netdev@vger.kernel.org
Subject: Re: [bug?] tg3: Failed to load firmware "tigon/tg3_tso.bin"
Message-ID: <20080707193008.17795d61@the-village.bc.nu>
In-Reply-To: <48726734.7080601@garzik.org>
References: <1215093175.10393.567.camel@pmac.infradead.org>
	<20080703173040.GB30506@mit.edu>
	<1215111362.10393.651.camel@pmac.infradead.org>
	<20080703.162120.206258339.davem@davemloft.net>
	<486D6DDB.4010205@infradead.org>
	<87ej6armez.fsf@basil.nowhere.org>
	<1215177044.10393.743.camel@pmac.infradead.org>
	<486E2260.5050503@garzik.org>
	<1215178035.10393.763.camel@pmac.infradead.org>
	<486E2818.1060003@garzik.org>
	<1215179161.10393.773.camel@pmac.infradead.org>
	<486E2E9B.20200@garzik.org>
	<20080704153822.4db2f325@lxorguk.ukuu.org.uk>
	<48715807.8070605@garzik.org>
	<20080707165333.6347f564@the-village.bc.nu>
	<48725155.2040007@garzik.org>
	<20080707191359.11f6297f@the-village.bc.nu>
	<48726734.7080601@garzik.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 07 Jul 2008 14:57:56 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> Alan Cox wrote:
> >> When the firmware travels with the module, as it does today in tg3, bnx2 
> >> and others, is the most reliable system available.  The simplest, the 
> >> least amount of "parts", the easiest to upgrade, the best method to 
> >> guarantee driver/firmware version matches.  It works wonderfully today.
> >>
> >> Is it difficult to see why someone might want to keep the same attributes?
> > 
> > No I can see that, should be a simple matter of sending David patches.
> 
> Isn't it David's obligation not to remove a highly reliable, working system?

I don't see why it should be David's job to add every conceivable feature
to the code. And this is the pot calling the kettle black. You badly
broke Marvell PATA support by setting the Marvell SATA devices to AHCI. I
note you've still not fixed that after some months.

Alan
