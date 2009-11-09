Return-Path: <linux-kernel-owner+w=401wt.eu-S1754226AbZKIE4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226AbZKIE4r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 23:56:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754124AbZKIE4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 23:56:45 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51259
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754073AbZKIE4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 23:56:45 -0500
Date: Sun, 08 Nov 2009 20:57:11 -0800 (PST)
Message-Id: <20091108.205711.153582422.davem@davemloft.net>
To: arnd@arndb.de
Cc: khc@pm.waw.pl, dwalker@fifo99.com, linux-kernel@vger.kernel.org,
       hch@lst.de, netdev@vger.kernel.org
Subject: Re: [PATCH 2/2] net/compat_ioctl: support SIOCWANDEV
From: David Miller <davem@davemloft.net>
In-Reply-To: <200911082239.24698.arnd@arndb.de>
References: <20091106.204753.223665411.davem@davemloft.net>
	<200911082231.48060.arnd@arndb.de>
	<200911082239.24698.arnd@arndb.de>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Sun, 8 Nov 2009 22:39:24 +0100

> This adds compat_ioctl support for SIOCWANDEV, which has
> always been missing.
> 
> The definition of struct compat_ifreq was missing an
> ifru_settings fields that is needed to support SIOCWANDEV,
> so add that and clean up the whitespace damage in the
> struct definition.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Applied, thanks.
