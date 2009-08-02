Return-Path: <linux-kernel-owner+w=401wt.eu-S1753438AbZHBTaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438AbZHBTaQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 15:30:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753392AbZHBTaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 15:30:15 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44880
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751908AbZHBTaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 15:30:14 -0400
Date: Sun, 02 Aug 2009 12:30:22 -0700 (PDT)
Message-Id: <20090802.123022.148176905.davem@davemloft.net>
To: bzolnier@gmail.com
Cc: pcnet32@verizon.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       error27@gmail.com, corbet@lwn.net, eteo@redhat.com, julia@diku.dk
Subject: Re: [PATCH] pcnet32: remove superfluous NULL pointer check in
 pcnet32_probe1()
From: David Miller <davem@davemloft.net>
In-Reply-To: <200907302319.18150.bzolnier@gmail.com>
References: <200907302319.18150.bzolnier@gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Thu, 30 Jul 2009 23:19:17 +0200

> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] pcnet32: remove superfluous NULL pointer check in pcnet32_probe1()
> 
> Move the debug printk() into the proper place and remove superfluous
> NULL pointer check in pcnet32_probe1().
> 
> This takes care of the following entry from Dan's list:
> 
> drivers/net/pcnet32.c +1889 pcnet32_probe1(298) warning: variable derefenced before check 'pdev'
> 
> Reported-by: Dan Carpenter <error27@gmail.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Applied, but please CC: netdev@vger.kernel.org for all future
network driver patches so that it gets properly tracked in
patchwork.  Thanks!
