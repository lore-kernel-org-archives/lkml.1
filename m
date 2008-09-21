Return-Path: <linux-kernel-owner+w=401wt.eu-S1753218AbYIUBPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218AbYIUBPd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 21:15:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751808AbYIUBPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 21:15:25 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41058
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751583AbYIUBPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 21:15:25 -0400
Date: Sat, 20 Sep 2008 18:15:12 -0700 (PDT)
Message-Id: <20080920.181512.80505160.davem@davemloft.net>
To: a.beregalov@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org
Subject: Re: [PATCH] serial_core: fix printk format warnings
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080921011131.GA16153@orion>
References: <20080921011131.GA16153@orion>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Beregalov <a.beregalov@gmail.com>
Date: Sun, 21 Sep 2008 05:11:31 +0400

> drivers/serial/serial_core.c:2158: warning: format '%x' expects type
> 'unsigned int', but argument 4 has type 'long unsigned int'
> drivers/serial/serial_core.c:2162: warning: format '%x' expects type
> 'unsigned int', but argument 4 has type 'long unsigned int
> 
> Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>

This is because of a patch of mine that Andrew added to -mm,
which changed the ioport to be an unsigned long.

I have some updates which I'll send to Andrew which should
cure this.
