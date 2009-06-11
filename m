Return-Path: <linux-kernel-owner+w=401wt.eu-S1759493AbZFKGsI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759493AbZFKGsI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 02:48:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758933AbZFKGrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 02:47:55 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33268
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758313AbZFKGrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 02:47:55 -0400
Date: Wed, 10 Jun 2009 23:47:57 -0700 (PDT)
Message-Id: <20090610.234757.215116002.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       slapin@ossfans.org
Subject: Re: linux-next: net tree build warnings
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090611145541.2570a43d.sfr@canb.auug.org.au>
References: <20090611145541.2570a43d.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 11 Jun 2009 14:55:41 +1000

> Today's linux-next build (x86_64 allmodconfig) produced these warnings:
> 
> net/ieee802154/raw.c: In function 'raw_sendmsg':
> net/ieee802154/raw.c:135: warning: format '%u' expects type 'unsigned int', but argument 2 has type 'size_t'
> net/ieee802154/dgram.c: In function 'dgram_sendmsg':
> net/ieee802154/dgram.c:251: warning: format '%u' expects type 'unsigned int', but argument 2 has type 'size_t'
> 
> Introduced by commit 9ec7671603573ede31207eb5b0b3e1aa211b2854 ("net: add
> IEEE 802.15.4 socket family implementation").

Similar to what you reported yesterday :-)

I'll get this fixed.

