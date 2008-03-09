Return-Path: <linux-kernel-owner+w=401wt.eu-S1753204AbYCIK0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204AbYCIK0S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 06:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751530AbYCIK0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 06:26:07 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:56141 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751150AbYCIK0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 06:26:04 -0400
Date: Sun, 9 Mar 2008 10:13:04 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
Cc: matthieu castet <castet.matthieu@free.fr>, linux-usb@vger.kernel.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]  mass storage : emulation of sat scsi_pass_thru with
 ATACB
Message-ID: <20080309101304.1fe76b6f@core>
In-Reply-To: <20080308183125.GB2820@one-eyed-alien.net>
References: <47D2CD95.9070701@free.fr>
	<20080308183125.GB2820@one-eyed-alien.net>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Mar 2008 10:31:25 -0800
Matthew Dharm <mdharm-kernel@one-eyed-alien.net> wrote:

> Why are you using an initializer instead of a new protocol code?
> 
> Most of this should probably be moved into it's own file, just like all of
> the other protocol handlers.

Would it perhaps be simpler to just attach the device to the ATA driver
and use the ATACB interface for everything ?

Alan
