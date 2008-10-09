Return-Path: <linux-kernel-owner+w=401wt.eu-S1757070AbYJIVom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757070AbYJIVom (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 17:44:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754442AbYJIVoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 17:44:34 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37966
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753596AbYJIVod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 17:44:33 -0400
Date: Thu, 09 Oct 2008 14:44:09 -0700 (PDT)
Message-Id: <20081009.144409.170605081.davem@davemloft.net>
To: tobias.brunner@strongswan.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.27-rc9] af_key: fix SADB_X_SPDDELETE response
From: David Miller <davem@davemloft.net>
In-Reply-To: <48EDF4AD.50907@strongswan.org>
References: <48EDF4AD.50907@strongswan.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tobias Brunner <tobias.brunner@strongswan.org>
Date: Thu, 09 Oct 2008 14:10:21 +0200

> When deleting an SPD entry using SADB_X_SPDDELETE, c.data.byid is not initialized to zero in pfkey_spddelete(). Thus, key_notify_policy() responds with a PF_KEY message of type SADB_X_SPDDELETE2 instead of SADB_X_SPDDELETE.
> 
> Signed-off-by: Tobias Brunner <tobias.brunner@strongswan.org>

This patch does not apply cleanly to net-next-2.6, a lot has
changed in this area over the past several weeks.

Please respin this so that I can add it, thanks.
