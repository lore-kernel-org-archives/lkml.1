Return-Path: <linux-kernel-owner+w=401wt.eu-S1756606AbYBSEod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606AbYBSEod (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 23:44:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752184AbYBSEoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 23:44:21 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43362
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752159AbYBSEoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 23:44:20 -0500
Date: Mon, 18 Feb 2008 20:44:57 -0800 (PST)
Message-Id: <20080218.204457.167455192.davem@davemloft.net>
To: hidave.darkstar@gmail.com
Cc: marcel@holtmann.org, linux-kernel@vger.kernel.org,
       bluez-devel@lists.sourceforge.net, netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] bluetooth : put hci dev after del conn
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080218075555.GA5940@darkstar.te-china.tietoenator.com>
References: <20080218075555.GA5940@darkstar.te-china.tietoenator.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Young <hidave.darkstar@gmail.com>
Date: Mon, 18 Feb 2008 15:55:55 +0800

> Move hci_dev_put to del_conn to avoid hci dev going away before hci conn.

This looks correct so I have applied it.

> Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 

Please remove the extraneous space at the end of your
signoff line next time :-)

Also, I reworked the loop in del_conn() so that it no longer
generates a compile warning, so I had to apply your patch
by hand.
