Return-Path: <linux-kernel-owner+w=401wt.eu-S1758168AbZJFSuJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758168AbZJFSuJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 14:50:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757111AbZJFSuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 14:50:08 -0400
Received: from khc.piap.pl ([195.187.100.11]:33681 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757475AbZJFSuH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 14:50:07 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: <linux-ide@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: sata_via: SError: { UnrecovData Proto TrStaTrns }
References: <m3my46yo5g.fsf@intrepid.localdomain>
	<19147.28614.505296.752363@pilspetsen.it.uu.se>
Date: Tue, 06 Oct 2009 20:49:29 +0200
In-Reply-To: <19147.28614.505296.752363@pilspetsen.it.uu.se> (Mikael
	Pettersson's message of "Tue, 6 Oct 2009 18:26:46 +0200")
Message-ID: <m3zl84we6e.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson <mikpe@it.uu.se> writes:

> I couldn't do much about it other than ask the person to take
> it to linux-ide (which I don't think he did), but it does make
> one wonder if there is some issue with the vt6421a when connected
> to an ixp4xx.

Well.

IXP4xx has some special properties like ability of PCI masters to access
only 64 MB of RAM (there is bounce buffering) and emulated inb/outb
operations. It's PCI bus can operate at 66 MHz, though in this case it's
set at 33 MHz (many mini-PCI cards assume 33 MHz while not grounding
M66EN line, it may result in 66 MHz).

ARM is bi-endian, though this machine runs little-endian.
-- 
Krzysztof Halasa
