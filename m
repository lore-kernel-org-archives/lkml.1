Return-Path: <linux-kernel-owner+w=401wt.eu-S1761210AbYCCK73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761210AbYCCK73 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 05:59:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756429AbYCCK7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 05:59:18 -0500
Received: from senator.holtmann.net ([87.106.208.187]:60196 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756321AbYCCK7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 05:59:17 -0500
Cc: tglx@linutronix.de, davem@davemloft.net, linux-bluetooth@vger.kernel.org,
       linux-kernel@vger.kernel.org
Message-Id: <B208AF85-1FAD-4913-ADD6-4A1FD2D33F3C@holtmann.org>
From: Marcel Holtmann <marcel@holtmann.org>
To: Dave Young <hidave.darkstar@gmail.com>
In-Reply-To: <20080303024845.GA3197@darkstar.te-china.tietoenator.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: Re: [PATCH] l2cap info_timer delete fix in hci_conn_del
Date: Mon, 3 Mar 2008 11:59:04 +0100
References: <20080303024845.GA3197@darkstar.te-china.tietoenator.com>
X-Mailer: Apple Mail (2.919.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

> When the l2cap info_timer is active the info_state will be set to
> L2CAP_INFO_FEAT_MASK_REQ_SENT, and it will be unset after the timer
> is deleted or timeout triggered.
>
> Here in hci_conn_del only call del_timer_sync when the info_state
> is set to L2CAP_INFO_FEAT_MASK_REQ_SENT.
>
> Signed-off-by: Dave Young <hidave.darkstar@gmail.com>

the comment should say l2cap_conn_del, but besides that, the patch is  
good.

Acked-by: Marcel Holtmann <marcel@holtmann.org>

in case someone is quicker than me getting this to Linus.

Regards

Marcel

