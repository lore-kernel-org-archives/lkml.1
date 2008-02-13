Return-Path: <linux-kernel-owner+w=401wt.eu-S1758612AbYBMCZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758612AbYBMCZe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 21:25:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754268AbYBMCZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 21:25:25 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:40999 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753345AbYBMCZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 21:25:24 -0500
Date: Wed, 13 Feb 2008 02:17:37 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <greg@kroah.com>
Cc: muli@il.ibm.com, jdmason@kudzu.us, bzolnier@gmail.com,
       linux-ide@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org, discuss@x86-64.org
Subject: Re: pci_get_device_reverse(), why does Calgary need this?
Message-ID: <20080213021737.72b9815d@core>
In-Reply-To: <20080213001638.GB13933@kroah.com>
References: <20080213001506.GA13933@kroah.com>
	<20080213001638.GB13933@kroah.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Why does the calgary driver need this?  Can we just use pci_get_device()
> instead?  Why do you need to walk the device list backwards?  Do you get
> false positives going forward?

It doesn't look to be performance critical so the driver can
pci_get_device until the end and use the final hit anyway. IDE reverse is
more problematic but nobody seems to use it.
