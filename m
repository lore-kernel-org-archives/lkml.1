Return-Path: <linux-kernel-owner+w=401wt.eu-S1754438AbYGSCeK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438AbYGSCeK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 22:34:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751169AbYGSCdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 22:33:55 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38107 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbYGSCdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 22:33:54 -0400
Date: Sat, 19 Jul 2008 03:33:51 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: David Miller <davem@davemloft.net>
Cc: randy.dunlap@oracle.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH -next] net namespace: build when SYSCTL=n
Message-ID: <20080719023351.GT28946@ZenIV.linux.org.uk>
References: <20080718171812.8dfc9767.randy.dunlap@oracle.com> <20080718.180107.126477208.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080718.180107.126477208.davem@davemloft.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 06:01:07PM -0700, David Miller wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> Date: Fri, 18 Jul 2008 17:18:12 -0700
> 
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> > When CONFIG_SYSCTL=n, build fails with:
> > 
> > linux-next-20080718/include/net/net_namespace.h:40: error: field 'sysctls' has incomplete type
> > 
> > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> 
> This 'sysctls' member isn't present in my networking tree, it must be
> coming from some other tree and thus the patch needs to be applied
> there.

Yup.  Applied.
