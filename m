Return-Path: <linux-kernel-owner+w=401wt.eu-S1758927AbZFWLTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758927AbZFWLTf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 07:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759012AbZFWLTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 07:19:18 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37424
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758885AbZFWLTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 07:19:15 -0400
Date: Tue, 23 Jun 2009 04:19:19 -0700 (PDT)
Message-Id: <20090623.041919.163057108.davem@davemloft.net>
To: heiko.carstens@de.ibm.com
Cc: richard.rojfors.ext@mocean-labs.com, schwidefsky@de.ibm.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net: let KS8842 driver depend on HAS_IOMEM
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090623073206.GB5955@osiris.boeblingen.de.ibm.com>
References: <20090623073206.GB5955@osiris.boeblingen.de.ibm.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>
Date: Tue, 23 Jun 2009 09:32:18 +0200

> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> Fixes this compile error on s390:
> 
>   CC      drivers/net/ks8842.o
> drivers/net/ks8842.c: In function 'ks8842_select_bank':
> drivers/net/ks8842.c:124: error: implicit declaration of function 'iowrite16'
> drivers/net/ks8842.c: In function 'ks8842_write8':
> drivers/net/ks8842.c:131: error: implicit declaration of function 'iowrite8'
> 
> Cc: Richard Rojfors <richard.rojfors.ext@mocean-labs.com>
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>

Applied.
