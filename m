Return-Path: <linux-kernel-owner+w=401wt.eu-S1765463AbYBLVEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765463AbYBLVEt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 16:04:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765392AbYBLVEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 16:04:30 -0500
Received: from gate.crashing.org ([63.228.1.57]:56797 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765384AbYBLVE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 16:04:28 -0500
Subject: Re: [PATCH 00/18] ide: warm-plug support for IDE devices and other
	goodies
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
In-Reply-To: <1202460043.7079.157.camel@pasglop>
References: <20080208004421.17746.32557.sendpatchset@localhost.localdomain>
	 <1202460043.7079.157.camel@pasglop>
Content-Type: text/plain
Date: Wed, 13 Feb 2008 08:04:07 +1100
Message-Id: <1202850247.7410.24.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-02-08 at 19:40 +1100, Benjamin Herrenschmidt wrote:
> On Fri, 2008-02-08 at 01:44 +0100, Bartlomiej Zolnierkiewicz wrote:
> > - couple of fixes and preparatory patches
> > 
> > - rework of PowerMac media-bay support ([un]register IDE devices instead of
> >   [un]registering IDE interface) [ it is the main reason for spamming PPC ML ]
> 
> Interesting... I was thinking about doing a full remove of the device at
> a higher level instead but I suppose what you propose is easier.
> 
> I'll have a look & test next week hopefully.

Also, the above would have the advantage of not relying on drivers/ide
infrastructure, and thus working with libata (once somebody has ported
pmac ide to libata).

Ben.


