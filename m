Return-Path: <linux-kernel-owner+w=401wt.eu-S932177AbXGNXti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932177AbXGNXti (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 19:49:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764514AbXGNXta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 19:49:30 -0400
Received: from khc.piap.pl ([195.187.100.11]:45848 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759844AbXGNXt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 19:49:29 -0400
To: William Montgomery <william@opinicus.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: e100 PCI bridge problem
References: <4697B85B.4040902@opinicus.com>
	<m33azrt5a6.fsf@maximus.localdomain> <46995998.70706@opinicus.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sun, 15 Jul 2007 01:49:27 +0200
In-Reply-To: <46995998.70706@opinicus.com> (William Montgomery's message of "Sat, 14 Jul 2007 19:17:44 -0400")
Message-ID: <m3d4yuczqw.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Montgomery <william@opinicus.com> writes:

> I am using a PCI analyzer and it shows the bus in an idle state after
> the lockup.  The PCI transactions just prior to the lockup show a
> couple of interrupts from the card which appear to be handled
> correctly.  Anything I should be looking for in particular?

I'd try to check with other machine using "secondary" bus slot.
BTW: Are you able to analyze the "primary" bus transactions while
using the card in "secondary" bus? Perhaps there is something
wrong in front of the motherboard bridge?

A broken motherboard may be hard to diagnose, unfortunately.

Can you post something like "lspci -vv" taken on both machines?
-- 
Krzysztof Halasa
