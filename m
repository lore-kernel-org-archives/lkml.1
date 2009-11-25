Return-Path: <linux-kernel-owner+w=401wt.eu-S1759898AbZKYW40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759898AbZKYW40 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 17:56:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759877AbZKYW4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 17:56:25 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45835
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759250AbZKYW4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 17:56:25 -0500
Date: Wed, 25 Nov 2009 14:56:43 -0800 (PST)
Message-Id: <20091125.145643.04893966.davem@davemloft.net>
To: andi@lisas.de
Cc: zambrano@broadcom.com, dave@thedillows.org, mb@bu3sch.de,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] b44.c box lockup fix (netconsole): ratelimit NAPI poll
 error message
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091125213546.GA6168@rhlx01.hs-esslingen.de>
References: <20091125213546.GA6168@rhlx01.hs-esslingen.de>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Mohr <andi@lisas.de>
Date: Wed, 25 Nov 2009 22:35:46 +0100

> Turns out that it's not very helpful to have a netconsole-deployed
> network driver's interrupt handler message spew noise permanently
> (see comment in patch).

It's not even an illegal state, especially with shared interrupts.
The warning should never be emitted.
