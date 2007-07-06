Return-Path: <linux-kernel-owner+w=401wt.eu-S1763651AbXGFJ7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763651AbXGFJ7n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 05:59:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760918AbXGFJ7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 05:59:35 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:56000 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752933AbXGFJ7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 05:59:34 -0400
Date: Fri, 6 Jul 2007 11:05:18 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andres Salomon <dilinger@queued.net>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jordan Crouse <jordan.crouse@amd.com>, info-linux@geode.amd.com,
       gregkh@suse.de, linux-pci@atrey.karlin.mff.cuni.cz, tsylla@gmail.com
Subject: Re: [PATCH] PCI: do not delay when changing power states on Geode
Message-ID: <20070706110518.13399132@the-village.bc.nu>
In-Reply-To: <20070705221351.97d14df0.dilinger@queued.net>
References: <20070705221351.97d14df0.dilinger@queued.net>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jul 2007 22:13:51 -0400
Andres Salomon <dilinger@queued.net> wrote:

> Geode hardware requires no delay when doing power transition for PCI;
> the board doesn't even have a real PCI bus.  Thanks to Tom Sylla for
> pointing this out.  We can save precious milliseconds when changing power
> states to D3hot by getting rid of this delay.
> 
> We do this as a PCI quirk.

NAK

These systems may have other components on them which require the proper
transition times and the CS5530 supports external real PCI devices.

Alan
