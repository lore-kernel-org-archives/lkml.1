Return-Path: <linux-kernel-owner+w=401wt.eu-S1755430AbYG3QEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430AbYG3QEd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 12:04:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751736AbYG3QEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 12:04:25 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44351 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751550AbYG3QEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 12:04:25 -0400
Date: Wed, 30 Jul 2008 16:47:18 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sanka Piyaratna <cesanka@yahoo.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PCIe device driver question
Message-ID: <20080730164718.1befdd07@lxorguk.ukuu.org.uk>
In-Reply-To: <125082.62307.qm@web31706.mail.mud.yahoo.com>
References: <125082.62307.qm@web31706.mail.mud.yahoo.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jul 2008 09:00:58 -0700 (PDT)
Sanka Piyaratna <cesanka@yahoo.com> wrote:

> Hi,
> 
> I am currently developing a PCIe data capture card hardware and the
> device drivers to drive this. I have implemented DMA on the data
> capture and the scatter-gather DMA is implemented in the hardware.  I
> am testing this in an X86_64 architecture machine with 4 GB of RAM. I
> am able to successfully dma data into any memory (dma) address >
> 0x0000_0001_0000_0000. However, my problem is to dma data to any
> address less than this. When I try to DMA data to an address less than
> 0x0000_0001_0000_0000, the hardware device hangs indicating that the
> address does not exist.

Assuming the failures are in the range 640K-1MB then I would imagine your
bridge doesn't permit transfers via DMA to the ISA hole.
