Return-Path: <linux-kernel-owner+w=401wt.eu-S1752694AbZEKFg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694AbZEKFg7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 01:36:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750910AbZEKFgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 01:36:50 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41227
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750816AbZEKFgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 01:36:49 -0400
Date: Sun, 10 May 2009 22:36:45 -0700 (PDT)
Message-Id: <20090510.223645.193708481.davem@davemloft.net>
To: michael@ellerman.id.au
Cc: matthew@wil.cx, jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix MSI-X with NIU cards
From: David Miller <davem@davemloft.net>
In-Reply-To: <1242004911.7767.26.camel@concordia>
References: <20090508131333.GV8112@parisc-linux.org>
	<1242004911.7767.26.camel@concordia>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Ellerman <michael@ellerman.id.au>
Date: Mon, 11 May 2009 11:21:51 +1000

> So I guess this device is just silently ignoring that write?

No, it signals a fault on the PCI bus, which is how we noticed
this problem in the first place.
