Return-Path: <linux-kernel-owner+w=401wt.eu-S1757907AbYGSBBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757907AbYGSBBU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 21:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752621AbYGSBBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 21:01:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41538
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752570AbYGSBBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 21:01:07 -0400
Date: Fri, 18 Jul 2008 18:01:07 -0700 (PDT)
Message-Id: <20080718.180107.126477208.davem@davemloft.net>
To: randy.dunlap@oracle.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH -next] net namespace: build when SYSCTL=n
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080718171812.8dfc9767.randy.dunlap@oracle.com>
References: <20080718171812.8dfc9767.randy.dunlap@oracle.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Fri, 18 Jul 2008 17:18:12 -0700

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> When CONFIG_SYSCTL=n, build fails with:
> 
> linux-next-20080718/include/net/net_namespace.h:40: error: field 'sysctls' has incomplete type
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

This 'sysctls' member isn't present in my networking tree, it must be
coming from some other tree and thus the patch needs to be applied
there.
