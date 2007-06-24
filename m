Return-Path: <linux-kernel-owner+w=401wt.eu-S1752612AbXFXQYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612AbXFXQYf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 12:24:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750971AbXFXQY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 12:24:28 -0400
Received: from khc.piap.pl ([195.187.100.11]:59414 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970AbXFXQY2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 12:24:28 -0400
To: pharon@gmail.com
Cc: Clemens Koller <clemens.koller@anagramm.de>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org
Subject: Re: Dual slot PCI riser messes up ivtv
References: <fa.ELPuDi4dcntxF8hk4oCNldcvgoc@ifi.uio.no>
	<467A89D4.6080607@shaw.ca> <4683D4A0.3000100@anagramm.de>
	<20070621162654.GA10008@csclub.uwaterloo.ca>
	<4683EA26.6030306@anagramm.de> <1182695244.6316.11.camel@iamer-laptop>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sun, 24 Jun 2007 18:24:24 +0200
In-Reply-To: <1182695244.6316.11.camel@iamer-laptop> (Islam Amer's message of "Sun, 24 Jun 2007 17:27:24 +0300")
Message-ID: <m3y7i9xqvb.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Islam Amer <pharon@gmail.com> writes:

> First the riser card is a dual slot one , with a chip on it so I assumed
> it is active.

Perhaps REQ/GNT arbiter. A PCI-PCI bridge is a 100+ pin chip.

> Third : The bug lies in the situation where the PVR-150 card is in the
> upper slot and the DVB card is in the lower slot, in which case the DVB
> card does not work. That was the dmesg output I posted earlier.

Interesting, the lower slot is probably wired directly to edge
connector so it should work. The upper connector should be the
problematic.
-- 
Krzysztof Halasa
