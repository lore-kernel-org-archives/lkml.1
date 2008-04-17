Return-Path: <linux-kernel-owner+w=401wt.eu-S1760689AbYDQNfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760689AbYDQNfm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 09:35:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753605AbYDQNfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 09:35:34 -0400
Received: from www.tglx.de ([62.245.132.106]:56432 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752691AbYDQNfe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 09:35:34 -0400
Date: Thu, 17 Apr 2008 15:35:28 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alex Dubov <oakad@yahoo.com>
cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: Smartmedia/xd card support - request for comments
In-Reply-To: <466372.69780.qm@web36702.mail.mud.yahoo.com>
Message-ID: <alpine.LFD.1.10.0804171121580.3261@apollo.tec.linutronix.de>
References: <466372.69780.qm@web36702.mail.mud.yahoo.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Apr 2008, Alex Dubov wrote:

> I've implemented, with generous help from JMicron, a native support
> for Smartmedia/xD picture card media. Currently, only JMicron
> backend is available, but TI expressed some interest in this too, so
> TI Flashmedia backend may soon follow.

> Smartmedia cards are quite akin to the dumb flash chips, but they
> have their quirks that put them aside as a separate media type.

Smartmedia cards _ARE_ dumb NAND flash chips in a thin plastic cover
with gold contacts. The access to those cards is supported in the mtd
subsystem since ages. Why are you trying to reinvent the wheel ?

The only missing piece is the FTL layer, but there was a halfways
working version in the old mtd CVS which should be still available.
 
> management of flash memory. I studied the mtd layer, but found it to
> be not very helpful, so I wrote my own FTL module.

Err, why is MTD not helpful ? It covers all the low level access to
the NAND Flash and has a flexible interface to adapt to hardware.

We really do not need a second incarnation of NAND flash software in
the kernel.

Thanks,
	tglx

 
