Return-Path: <linux-kernel-owner+w=401wt.eu-S1756175AbZIKTg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175AbZIKTg4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 15:36:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756142AbZIKTg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 15:36:56 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57534
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752318AbZIKTgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 15:36:55 -0400
Date: Fri, 11 Sep 2009 12:37:11 -0700 (PDT)
Message-Id: <20090911.123711.04912729.davem@davemloft.net>
To: mikpe@it.uu.se
Cc: buytenh@marvell.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 2.6.31-rc9] mv643xx_eth.c: remove unused txq_set_wrr()
From: David Miller <davem@davemloft.net>
In-Reply-To: <200909070959.n879xGui019854@pilspetsen.it.uu.se>
References: <200909070959.n879xGui019854@pilspetsen.it.uu.se>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikael Pettersson <mikpe@it.uu.se>
Date: Mon, 7 Sep 2009 11:59:16 +0200 (MEST)

> The txq_set_wrr() function in drivers/net/mv643xx_eth.c is
> unused, not even referenced under #if 0 or something like that,
> which results in a compile-time warning:
> 
> drivers/net/mv643xx_eth.c:1070: warning: 'txq_set_wrr' defined but not used
> 
> Fix: remove it.
> 
> Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>

Applied.
