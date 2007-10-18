Return-Path: <linux-kernel-owner+w=401wt.eu-S1761442AbXJRAHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761442AbXJRAHk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 20:07:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758455AbXJRAHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 20:07:33 -0400
Received: from khc.piap.pl ([195.187.100.11]:43244 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758275AbXJRAHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 20:07:32 -0400
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-user@lists.sourceforge.net, lkml <linux-kernel@vger.kernel.org>
Subject: Re: VIA VT6307 OHCI version?
References: <m3sl4ciz1h.fsf@maximus.localdomain>
	<4714EF01.2060609@s5r6.in-berlin.de>
	<m3d4vebylw.fsf@maximus.localdomain>
	<471527E5.1050407@s5r6.in-berlin.de>
	<m34pgpmszu.fsf@maximus.localdomain>
	<47166C83.2050207@s5r6.in-berlin.de>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Thu, 18 Oct 2007 02:07:30 +0200
In-Reply-To: <47166C83.2050207@s5r6.in-berlin.de> (Stefan Richter's message of "Wed, 17 Oct 2007 22:11:47 +0200")
Message-ID: <m3fy09ffp9.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter <stefanr@s5r6.in-berlin.de> writes:

> And are you going to test if and how stable OHCI 1.1 features work?

I've "upgraded" the other machine ("b"), it uses the same VT6307
(not sure the packaging letter but I've already closed the case)
and is made in 2006 (week 22 or 20).

firewire_ohci: Added fw-ohci device 0000:02:03.0, OHCI version 1.10
firewire_core: created new fw device fw0 (0 config rom retries)
firewire_core: created new fw device fw1 (0 config rom retries)
firewire_core: phy config: card 0, new root=ffc1, gap_count=5

Just watching live DV stream across Ethernet from this machine.

OTOH, it's no magic - they claim OHCI 1.1 and they do it. We don't
only know how to enable it with (only) software. I suspect all those
VT6306 could be "upgraded" as well.
-- 
Krzysztof Halasa
