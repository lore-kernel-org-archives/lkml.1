Return-Path: <linux-kernel-owner+w=401wt.eu-S1755156AbYGVOlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156AbYGVOlA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 10:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753213AbYGVOkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 10:40:42 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41160 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751769AbYGVOkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 10:40:41 -0400
Date: Tue, 22 Jul 2008 15:23:30 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sean Young <sean@mess.org>
Cc: Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Led driver for technologic systems 5500
Message-ID: <20080722152330.7dc860b5@lxorguk.ukuu.org.uk>
In-Reply-To: <20080722141823.GA81435@atlantis.8hz.com>
References: <20080721211403.GB72268@atlantis.8hz.com>
	<1216715492.5421.1.camel@dax.rpnet.com>
	<20080722141823.GA81435@atlantis.8hz.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think that's why DMI was invented, AFAIK. I have no idea whether how many
> X86 devices exist on these I/O ports (0x77/0x74). The only other thing I can 
> think of is that this is an AMD Elan so the Kconfig could depend on ELAN 
> and not X86

If it is ELAN hardware then checking for an ELAN system would certainly
cut down a lot on the misdetects. Does the box have other unique
signatures you might detect. Good candidates we've used in the past have
been

- PCI subvendor identifiers
- BIOS strings (eg does the BIOS contain the sequence 'Technologic
systems 5500' or similar anywhere)

Alan
