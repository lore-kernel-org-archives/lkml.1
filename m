Return-Path: <linux-kernel-owner+w=401wt.eu-S1755710AbYG2Xnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710AbYG2Xnl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 19:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753024AbYG2Xnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 19:43:33 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37946 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753014AbYG2Xnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 19:43:32 -0400
Date: Wed, 30 Jul 2008 00:26:22 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "David Wilson" <mcs6502@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: pci_ids.h - duplicate entry and many out of order definitions
Message-ID: <20080730002622.47bd7569@lxorguk.ukuu.org.uk>
In-Reply-To: <3666888f0807291600n3c259c20wccc4896b2df3d0d8@mail.gmail.com>
References: <3666888f0807291600n3c259c20wccc4896b2df3d0d8@mail.gmail.com>
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

On Wed, 30 Jul 2008 09:00:09 +1000
"David Wilson" <mcs6502@gmail.com> wrote:

> I was browsing the pci_ids.h file and came across a duplicate entry
> for PCI_VENDOR_ID_RDC. This prompted me to look further and I found a
> number of out-of-order definitions (based on the comment at the head
> of the file that indicates that they should be sorted). I decided to
> write a script to check this and it found 74 "errors".
> 
> 1) Is it worth my time generating a patch to fix all these mis-orderings?
> 2) Should it be one large patch or many small ones (eg one per PCI_VENDOR)?
> 3) Is there a maintainer for this file?

1. Yes
2. It depends how big the patch is. I like the idea of one per vendor
sorting the vendor device entries into order and one then putting the
vendors in order. That would be easy to check/read
3. jbarnes@virtuousgeek.org

(in theory. I don' t know if he thinks its his file yet ;))
