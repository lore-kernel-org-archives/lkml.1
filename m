Return-Path: <linux-kernel-owner+w=401wt.eu-S1757304AbYCZPeN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304AbYCZPeN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 11:34:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753847AbYCZPd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 11:33:59 -0400
Received: from ihemail4.lucent.com ([135.245.0.39]:52569 "EHLO
	ihemail4.lucent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697AbYCZPd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 11:33:58 -0400
Date: Wed, 26 Mar 2008 11:28:13 -0400 (EDT)
Message-Id: <20080326.112813.200421960.pfps@research.bell-labs.com>
To: htejun@gmail.com
Cc: pfps@verizon.net, alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc9-git4: pata_pcmcia, disabling IRQ #9 and Re: libata
 and legacy ide pcmcia failure
From: "Peter F. Patel-Schneider" <pfps@research.bell-labs.com>
In-Reply-To: <47EA6157.6090208@gmail.com>
References: <20080321011205.4c7b4a61@core>
	<47EA5A13.70109@verizon.net>
	<47EA6157.6090208@gmail.com>
X-Mailer: Mew version 5.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Mar 2008 15:33:38.0923 (UTC) FILETIME=[C374CBB0:01C88F56]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <htejun@gmail.com>
Subject: Re: 2.6.23-rc9-git4: pata_pcmcia, disabling IRQ #9 and Re: libata and legacy ide pcmcia failure
Date: Wed, 26 Mar 2008 23:44:39 +0900

[Problems with PCMCIA adapter and CF card on ThinkPad T60p.]

> Does irqpoll help?

Yes!

Booting with the irqpoll boot option results in correct behaviour even
with repeated insertions and removals (with or without unmounting from
desktop) and when booting with or without the adapter and card inserted.
Much better (but slower).

Booting without the irqpoll boot option and no adapter and card in at
boot results in the bad behaviour when the adapter and card are first
inserted.  Booting without the irqpoll boot option and the adapter and
card in at boot results in more-or-less correct behaviour (there is an
extra icon on the desktop for the media, but this is a known problem and
probably not related), although in the past the behaviour in this
situation has been somewhat non-deterministic.

Problem solved?  Or not?

> -- 
> tejun

peter
