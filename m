Return-Path: <linux-kernel-owner+w=401wt.eu-S1754096AbYKFXvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096AbYKFXvQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 18:51:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752367AbYKFXu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 18:50:57 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52667
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751481AbYKFXu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 18:50:56 -0500
Date: Thu, 06 Nov 2008 15:50:55 -0800 (PST)
Message-Id: <20081106.155055.158286541.davem@davemloft.net>
To: jeff@garzik.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [git patches] net driver fixes for 2.6.28-rc
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081106065003.GA19105@havoc.gtf.org>
References: <20081106065003.GA19105@havoc.gtf.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Garzik <jeff@garzik.org>
Date: Thu, 6 Nov 2008 01:50:03 -0500

> Mark McLoughlin (2):
>       virtio_net: don't set NETIF_F_FRAGLIST
>       tun: don't set NETIF_F_FRAGLIST

These patches aren't correct, the drivers do in fact handle fragment
lists properly as was discussed in the threads where these patches
were posted.

Please pull these changes out and resend your pull request, thanks Jeff!
