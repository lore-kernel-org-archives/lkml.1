Return-Path: <linux-kernel-owner+w=401wt.eu-S1756512AbZFXJga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756512AbZFXJga (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 05:36:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758340AbZFXJgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 05:36:19 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48651
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758285AbZFXJgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 05:36:18 -0400
Date: Wed, 24 Jun 2009 02:36:22 -0700 (PDT)
Message-Id: <20090624.023622.26554425.davem@davemloft.net>
To: alan@lxorguk.ukuu.org.uk
Cc: bzolnier@gmail.com, elendil@planet.nl, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cs5520: add missing IRQ setup for the second port
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090624102200.7debd041@lxorguk.ukuu.org.uk>
References: <20090623163324.715421f5@lxorguk.ukuu.org.uk>
	<20090623.164429.179899088.davem@davemloft.net>
	<20090624102200.7debd041@lxorguk.ukuu.org.uk>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Wed, 24 Jun 2009 10:22:00 +0100

>> What should we do?  I guess "do nothing and wait until we see a bug
>> report from an actual user" is a valid response...
> 
> I doubt you ever will.
> 
> The docs don't say so I'd assume its hard coded 14/15 as if it was ISA
> (its not an IDE storage class device so doesn't have the PCI config bits
> to switch between legacy and native modes).

Ok, that makes sense.  I'll set the second port's IRQ to 15.

Thanks!
