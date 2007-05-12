Return-Path: <linux-kernel-owner+w=401wt.eu-S1759999AbXELUEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759999AbXELUEQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 16:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754998AbXELUEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 16:04:07 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:43511 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754797AbXELUEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 16:04:05 -0400
Date: Sat, 12 May 2007 21:08:30 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mark Glines <mark@glines.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch] ip_local_port_range sysctl has annoying default
Message-ID: <20070512210830.514c7709@the-village.bc.nu>
In-Reply-To: <20070512123052.4a628fa1@chirp>
References: <20070511170135.7c38615f@chirp>
	<4645227F.3030905@zytor.com>
	<20070512121009.18c8b68a@chirp>
	<464611A6.3040301@zytor.com>
	<20070512123052.4a628fa1@chirp>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > I think the IANA range is considered too small in most cases; I
> > suspect there is also a feeling that "there be dragons" near the very
> > top.
> 
> Ok, thanks for the explanation.  Sounds like we're using high port
> numbers in the "spirit" of the IANA recommendation, without using
> their actual numbers.

The top space is reserved when using masquerading and used for the
masquerading ports normally in that situation. Clipping them off avoids
differing behaviour with masquerading on/off.

Alan
