Return-Path: <linux-kernel-owner+w=401wt.eu-S1756888AbZLIEms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888AbZLIEms (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 23:42:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755784AbZLIEmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 23:42:44 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38783
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755850AbZLIEmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 23:42:43 -0500
Date: Tue, 08 Dec 2009 20:42:49 -0800 (PST)
Message-Id: <20091208.204249.02307242.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] drivers/net/au1000_eth.c: Remove misuse of
 DECLARE_MAC_BUF
From: David Miller <davem@davemloft.net>
In-Reply-To: <1260131563.11126.124.camel@Joe-Laptop.home>
References: <1260131563.11126.124.camel@Joe-Laptop.home>
X-Mailer: Mew version 6.2 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Sun, 06 Dec 2009 12:32:43 -0800

> And use a directly declared buffer.
> 
> It's used in a call to prom_get_ethernet_addr to
> get a 6 byte address, not a formatted output string.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

This DECLARE_MAC_BUF reference is already moved in the tree.
