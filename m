Return-Path: <linux-kernel-owner+w=401wt.eu-S1030290AbXBTRAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030290AbXBTRAQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 12:00:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030287AbXBTRAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 12:00:16 -0500
Received: from ftp.linux-mips.org ([194.74.144.162]:58508 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030280AbXBTRAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 12:00:14 -0500
Date: Tue, 20 Feb 2007 17:00:06 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Dale Farnsworth <dale@farnsworth.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] Eliminate user-selectable CONFIG_MV643XX_ETH_[012]
Message-ID: <20070220170006.GA29854@linux-mips.org>
References: <20070220121520.GA17927@xyzzy.farnsworth.org> <45DB2172.1070003@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45DB2172.1070003@garzik.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 20, 2007 at 11:27:30AM -0500, Jeff Garzik wrote:

> >It was a mis-feature that the supported ports were ever user-selectable.
> >Which ports the hardware supports should be specified by platform-specific
> >code, not by the user.
> >
> > arch/mips/momentum/jaguar_atx/platform.c |   21 ---------------------
> > arch/mips/momentum/ocelot_3/platform.c   |   21 ---------------------
> > arch/mips/momentum/ocelot_c/platform.c   |   14 --------------
> > arch/ppc/Kconfig                         |   15 +++++++++++++++
> > drivers/net/Kconfig                      |   21 ---------------------
> > 5 files changed, 15 insertions(+), 77 deletions(-)
> 
> ACK.
> 
> I'll let Paul, Ralf or Andrew push this one upstream.

Okay, will do that.

  Ralf
