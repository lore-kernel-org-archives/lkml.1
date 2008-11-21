Return-Path: <linux-kernel-owner+w=401wt.eu-S1756139AbYKULO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139AbYKULO7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 06:14:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755199AbYKULOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 06:14:41 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44265 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754321AbYKULOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 06:14:40 -0500
Date: Fri, 21 Nov 2008 11:13:48 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: LKML <linux-kernel@vger.kernel.org>, greg@kroah.com,
       linux-pci@vger.kernel.org, isdn4linux@listserv.isdn4linux.de,
       kkeil@suse.de, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: CONFIG_PCI_LEGACY removal
Message-ID: <20081121111348.6dad16cf@lxorguk.ukuu.org.uk>
In-Reply-To: <20081121181426.9f5efa36.sfr@canb.auug.org.au>
References: <20081121181426.9f5efa36.sfr@canb.auug.org.au>
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

On Fri, 21 Nov 2008 18:14:26 +1100
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi all,
> 
> Now that it is more than a year since CONFIG_PCI_LEGACY was added (Oct
> 2007) and longer since pci_find_slot() (May 2007) and pci_find_device()
> (Nov 2006) were deprecated, is there any way that we can get rid of the
> last vestiges of them?

Jeff Garzik I believe it was posted patches to do this. They were ignored
and the old ISDN code appears unmaintained. These drivers should IMHO
therefore be marked as BROKEN in 2.6.28 or Jeff's patch applied. Ditto
for the old cpq driver.

If Jeff's patch is wrong we'll find out if anyone even uses that code.
