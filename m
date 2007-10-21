Return-Path: <linux-kernel-owner+w=401wt.eu-S1752076AbXJUXYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbXJUXYv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 19:24:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751024AbXJUXYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 19:24:41 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39687
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750942AbXJUXYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 19:24:40 -0400
Date: Sun, 21 Oct 2007 16:24:54 -0700 (PDT)
Message-Id: <20071021.162454.71185083.davem@davemloft.net>
To: randy.dunlap@oracle.com
Cc: nish.aravamudan@gmail.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, chas@cmf.nrl.navy.mil
Subject: Re: atm: panic when loading clip 2nd time
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071019180236.cbc000a2.randy.dunlap@oracle.com>
References: <47152758.5000900@oracle.com>
	<29495f1d0710161433h6e4e90a6r32c89c2a89af2f90@mail.gmail.com>
	<20071019180236.cbc000a2.randy.dunlap@oracle.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Fri, 19 Oct 2007 18:02:36 -0700

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> net/atm/clip.c crashes the kernel if it (module) is loaded, removed,
> and then loaded again.  Its exit call to neigh_table_clear()
> should destroy the cache after freeing it.
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Looks good to me, applied, thanks!
