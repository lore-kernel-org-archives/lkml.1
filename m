Return-Path: <linux-kernel-owner+w=401wt.eu-S1761240AbZFXQlb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761240AbZFXQlb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 12:41:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760551AbZFXQl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 12:41:26 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45776 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759909AbZFXQl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 12:41:26 -0400
Date: Wed, 24 Jun 2009 17:42:50 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, kevin.huang@rdc.com.tw, greg@kroah.com
Subject: Re: [PATCH] pata_rdc: driver for RDC ATA devices
Message-ID: <20090624174250.6a0dcebe@lxorguk.ukuu.org.uk>
In-Reply-To: <1245861503.29098.102.camel@Joe-Laptop.home>
References: <20090624170944.24250.99267.stgit@t61.ukuu.org.uk>
	<1245861503.29098.102.camel@Joe-Laptop.home>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Maybe consolidate?
> 
> The code seems to have many magic constants that might
> be better #define'd and or'd.

If you've got the spec it doesn't go around trying to award hundreds of
bits obscure names so naming them would be silly. If you've not got the
spec then whether its WOMBAT_DERANDOMISE or 0x04 doesn't really make any
difference to your understanding ;)

(And the spec is public)

It's simply a cut down from ata_piix. If you want to clean up ata_piix a
bit then go for it - send patches to Jeff.

