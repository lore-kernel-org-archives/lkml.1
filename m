Return-Path: <linux-kernel-owner+w=401wt.eu-S1761809AbZLJVvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761809AbZLJVvd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 16:51:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761713AbZLJVvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 16:51:32 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34226
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761561AbZLJVvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 16:51:31 -0500
Date: Thu, 10 Dec 2009 13:51:38 -0800 (PST)
Message-Id: <20091210.135138.263963420.davem@davemloft.net>
To: randy.dunlap@oracle.com
Cc: sfr@canb.auug.org.au, netdev@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] net: niu uses crc32, so select CRC32
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091210093103.eda05dfe.randy.dunlap@oracle.com>
References: <20091210175919.340b4c0c.sfr@canb.auug.org.au>
	<20091210093103.eda05dfe.randy.dunlap@oracle.com>
X-Mailer: Mew version 6.2 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Thu, 10 Dec 2009 09:31:03 -0800

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> niu drivers uses crc32 functions, so it needs to select CRC32.
> 
> niu.c:(.text+0x18a7f8): undefined reference to `crc32_le'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Applied, thanks Randy.

That dependency is quite indirect, it's due to ether_crc_*().
I bet a quick grep for that will find several other drivers
missing this Kconfig bit.
