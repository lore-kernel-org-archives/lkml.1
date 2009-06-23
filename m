Return-Path: <linux-kernel-owner+w=401wt.eu-S1759136AbZFWLTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759136AbZFWLTW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 07:19:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757298AbZFWLTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 07:19:12 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37419
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756271AbZFWLTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 07:19:10 -0400
Date: Tue, 23 Jun 2009 04:19:14 -0700 (PDT)
Message-Id: <20090623.041914.57415991.davem@davemloft.net>
To: heiko.carstens@de.ibm.com
Cc: wg@grandegger.com, oliver.hartkopp@volkswagen.de, schwidefsky@de.ibm.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] can: let SJA1000 driver depend on HAS_IOMEM
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090623073120.GA5955@osiris.boeblingen.de.ibm.com>
References: <20090623073120.GA5955@osiris.boeblingen.de.ibm.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>
Date: Tue, 23 Jun 2009 09:31:20 +0200

> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> Fixes this compile error on s390:
> 
> drivers/net/can/sja1000/sja1000_platform.c: In function 'sp_read_reg':
> drivers/net/can/sja1000/sja1000_platform.c:42: error: implicit declaration of function 'ioread8'
> drivers/net/can/sja1000/sja1000_platform.c: In function 'sp_write_reg':
> drivers/net/can/sja1000/sja1000_platform.c:47: error: implicit declaration of function 'iowrite8'
> drivers/net/can/sja1000/sja1000_platform.c: In function 'sp_probe':
> drivers/net/can/sja1000/sja1000_platform.c:79: error: implicit declaration of function 'ioremap_nocache'
> 
> Cc: Wolfgang Grandegger <wg@grandegger.com>
> Cc: Oliver Hartkopp <oliver.hartkopp@volkswagen.de>
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>

Applied.
