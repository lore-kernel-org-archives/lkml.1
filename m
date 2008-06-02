Return-Path: <linux-kernel-owner+w=401wt.eu-S1758055AbYFBHUQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758055AbYFBHUQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 03:20:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752867AbYFBHUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 03:20:04 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42656 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750936AbYFBHUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 03:20:02 -0400
Date: Mon, 2 Jun 2008 08:04:40 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Pavel Machek <pavel@ucw.cz>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       Theodore Tso <tytso@mit.edu>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ata: ahci: power off unused ports
Message-ID: <20080602080440.25fc663c@core>
In-Reply-To: <4842F5A8.9020708@garzik.org>
References: <20080508161008.59361de5@appleyard>
	<20080527030854.GC7515@mit.edu>
	<20080527143202.4bab5bf0@appleyard>
	<20080527225926.GE6843@mit.edu>
	<20080527163251.04054a74@appleyard>
	<20080531080015.GG5405@ucw.cz>
	<4842F5A8.9020708@garzik.org>
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

> If you are talking about SATA -- incorrect.
> 
> The patch deals with policy, and the user MUST have the ability to 
> control this stuff.  Otherwise you create a situation where the user 
> might be denied hotplug use in valid cases, or similar negative situations.

The policy isn't however complicated. Tejun added the stuff for forcing
cable type and mode on setup and has therefore written all the per device
setup code we might need. Alternatively a single

	foo=1/0

option has been fine for acpi and will do fine for this. Total additional
cost - 1 line.

Alan
