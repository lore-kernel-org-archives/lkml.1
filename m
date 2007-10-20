Return-Path: <linux-kernel-owner+w=401wt.eu-S1765477AbXJTNDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765477AbXJTNDf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 09:03:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754291AbXJTND2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 09:03:28 -0400
Received: from khc.piap.pl ([195.187.100.11]:33911 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615AbXJTND1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 09:03:27 -0400
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-user@lists.sourceforge.net, lkml <linux-kernel@vger.kernel.org>
Subject: Re: VIA VT6307 OHCI version?
References: <m3sl4ciz1h.fsf@maximus.localdomain>
	<4714EF01.2060609@s5r6.in-berlin.de>
	<m3d4vebylw.fsf@maximus.localdomain>
	<471527E5.1050407@s5r6.in-berlin.de>
	<m34pgpmszu.fsf@maximus.localdomain>
	<47166C83.2050207@s5r6.in-berlin.de>
	<m3fy09ffp9.fsf@maximus.localdomain>
	<4719A0C4.3050301@s5r6.in-berlin.de>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sat, 20 Oct 2007 15:03:24 +0200
In-Reply-To: <4719A0C4.3050301@s5r6.in-berlin.de> (Stefan Richter's message of "Sat, 20 Oct 2007 08:31:32 +0200")
Message-ID: <m3bqausztv.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter <stefanr@s5r6.in-berlin.de> writes:

> What if we add a whitelisting in the driver which ignores the register
> contents which state OHCI 1.0 implementation level, and just treats
> these VIA chips as OHCI 1.1 implementations?

It would be interesting but I'm not sure it would work. I guess
if these chips are in OHCI 1.0 mode the 1.1 functionality may be
unavailable (the datasheet seems to suggest that).

OTOH I think it's better to change the EEPROM contents anyway,
it's a simple program (which I'm going to write when I'm a bit
less loaded).

I wonder if OHCI 1.0 hardware based on VT6307 (and 6306) is
a common thing, or is it just an exception.
-- 
Krzysztof Halasa
