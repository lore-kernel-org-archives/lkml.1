Return-Path: <linux-kernel-owner+w=401wt.eu-S1763148AbXIZW5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763148AbXIZW5i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 18:57:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760898AbXIZW5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 18:57:31 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41216
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756634AbXIZW5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 18:57:30 -0400
Date: Wed, 26 Sep 2007 15:57:26 -0700 (PDT)
Message-Id: <20070926.155726.43027883.davem@davemloft.net>
To: shemminger@linux-foundation.org
Cc: jengelh@computergmbh.de, olecom@flower.upol.cz, jbeulich@novell.com,
       bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: why network devices don't do reference counting?
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070926153330.77aade4d@freepuppy.rosehill>
References: <20070926140608.6e6d3d0c@freepuppy.rosehill>
	<Pine.LNX.4.64.0709270017120.17414@fbirervta.pbzchgretzou.qr>
	<20070926153330.77aade4d@freepuppy.rosehill>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <shemminger@linux-foundation.org>
Date: Wed, 26 Sep 2007 15:33:30 -0700

> ipv6 is not a network driver, it is a protocol. You might be able to
> remove it if you zap all the routes and applications, ...

It is purposefully set to have a permanent elevated reference
count because it is not designed to be unloaded safely.

It has been unloadable forever.
