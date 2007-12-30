Return-Path: <linux-kernel-owner+w=401wt.eu-S1754599AbXL3DTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599AbXL3DTP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 22:19:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752920AbXL3DTB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 22:19:01 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35330
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752865AbXL3DTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 22:19:01 -0500
Date: Sat, 29 Dec 2007 19:18:55 -0800 (PST)
Message-Id: <20071229.191855.100656438.davem@davemloft.net>
To: hidave.darkstar@gmail.com
Cc: marcel@holtmann.org, akpm@linux-foundation.org, greg@kroah.com,
       linux-kernel@vger.kernel.org, bluez-devel@lists.sourceforge.net
Subject: Re: [BUG][PATCH] bluetooth: put_device before device_del fix
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071227052750.GA6296@darkstar.te-china.tietoenator.com>
References: <20071227052750.GA6296@darkstar.te-china.tietoenator.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Young <hidave.darkstar@gmail.com>
Date: Thu, 27 Dec 2007 13:27:50 +0800

> Because of workqueue delay, the put_device could be called before device_del, so move it to del_conn.
> 
> Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 

Applied, thanks Dave.

Please post bluetooth patches, just like any other networking patches,
to netdev@vger.kernel.org (CC:'ing me) so that other networking
developers can process them during times like these when most
maintainers aren't around and thus not looking at bug fixes like
your's.

Thanks.
