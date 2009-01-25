Return-Path: <linux-kernel-owner+w=401wt.eu-S1756010AbZAYLHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010AbZAYLHn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 06:07:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752094AbZAYLHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 06:07:33 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47405 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752060AbZAYLHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 06:07:32 -0500
Date: Sun, 25 Jan 2009 11:07:42 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Switching from (deprecated) IDE driver -> SATA (PATA support)
Message-ID: <20090125110742.4ba54c0b@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.DEB.1.10.0901250553430.2441@p34.internal.lan>
References: <alpine.DEB.1.10.0901250553430.2441@p34.internal.lan>
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

> and I cannot upgrade the kernel anymore unless I move to the 
> PATA-supported SATA driver, but I have no idea what the root disk will be 
> after a reboot and there is a high probability it will not come back after 
> a reboot..

Easiest is to use labels. Old ide will keep hda,b,c,d constant
providing you have interfaces using the legacy IDE port mappings (0x1f0
and 0x170). Libata doesn't do that as pretty much every distribution had
already switched to volume labels, and the user space can do the job far
better than the kernel - especially as the newer devices with modern
interfaces don't have the old BIOS/DOS legacy ideas any more.

Mount by label also means you can flip back and forth between the
different drivers and kernel revisions.

Alan
