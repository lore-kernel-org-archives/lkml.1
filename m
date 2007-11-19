Return-Path: <linux-kernel-owner+w=401wt.eu-S1754343AbXKSWbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343AbXKSWbZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 17:31:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752262AbXKSWbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 17:31:17 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45230
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752014AbXKSWbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 17:31:16 -0500
Date: Mon, 19 Nov 2007 14:31:15 -0800 (PST)
Message-Id: <20071119.143115.251022325.davem@davemloft.net>
To: benh@kernel.crashing.org
Cc: James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, rmk@arm.linux.org.uk
Subject: Re: SCSI breakage on non-cache coherent architectures
From: David Miller <davem@davemloft.net>
In-Reply-To: <1195501874.6539.5.camel@pasglop>
References: <1195450523.7022.37.camel@pasglop>
	<20071119.003802.100741794.davem@davemloft.net>
	<1195501874.6539.5.camel@pasglop>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Tue, 20 Nov 2007 06:51:14 +1100

> On Mon, 2007-11-19 at 00:38 -0800, David Miller wrote:
> > From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > Date: Mon, 19 Nov 2007 16:35:23 +1100
> > 
> > You could make a ____dma_cacheline_aligned and use that.
> > It seems pretty reasonable.
> 
> I was thinking about that. What archs would need it ? arm, mips, what
> else ?

The sparc32 port would need it too.

