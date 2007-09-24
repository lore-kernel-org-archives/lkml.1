Return-Path: <linux-kernel-owner+w=401wt.eu-S1756284AbXIXCC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284AbXIXCC2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 22:02:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754115AbXIXCCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 22:02:20 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:5156 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754090AbXIXCCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 22:02:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:references:subject:message-id:x-mailer;
        b=EdWcRqnqkOwuDAisq/YQQGvipHtLd3uGyXyEL38qrOgxZi+P1Li2ZMAqtH9GItnfoE6VBA1hMy2chJZTiGCXXTKcwXEV6DQHhLzzqM4LWg+i4fCqSo/0lkph9Xo/xeXnO0e1vVjUZN3bNo0q9K5Tr4NuybZjapkhJGOTSHW/HwM=
Date: Mon, 24 Sep 2007 10:02:12 +0800
From: "Peer Chen" <peerchen@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-ide" <linux-ide@vger.kernel.org>,
       "akpm" <akpm@linux-foundation.org>, "jeff" <jeff@garzik.org>
References: <200709211406065332552@gmail.com>,
 <20070921113908.180cd154@the-village.bc.nu>
Subject: Re: Re: [PATCH] ahci: Add MCP79 support to AHCI driver
Message-ID: <200709241002079067823@gmail.com>
X-mailer: Foxmail 6, 6, 105, 21 [cn]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yes,it's necessary because our RAID controller also use the ahci driver.

------------------				 
Peer Chen
2007-09-24

-------------------------------------------------------------
发件人：Alan Cox
发送日期：2007-09-21 18:32:09
收件人：Peer Chen
抄送：linux-kernel; linux-ide; akpm; jeff
主题：Re: [PATCH] ahci: Add MCP79 support to AHCI driver

On Fri, 21 Sep 2007 14:06:10 +0800
"Peer Chen" <peerchen@gmail.com> wrote:

> Add the MCP79 support to ahci driver.
> The patch base on kernel 2.6.23-rc7

Is this actually needed or as they are standard ahci devices will the
class match get them anyway ?

