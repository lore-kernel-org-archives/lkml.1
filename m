Return-Path: <linux-kernel-owner+w=401wt.eu-S1757840AbZBSBx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757840AbZBSBx3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 20:53:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753443AbZBSBxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 20:53:17 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54146
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753235AbZBSBxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 20:53:16 -0500
Date: Wed, 18 Feb 2009 17:53:01 -0800 (PST)
Message-Id: <20090218.175301.153945217.davem@davemloft.net>
To: baranov@mercdev.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] niu: fix PHY template choice for 10G copper
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090217103833.ec37526d.baranov@mercdev.com>
References: <20090217103833.ec37526d.baranov@mercdev.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Constantin Baranov <baranov@mercdev.com>
Date: Tue, 17 Feb 2009 10:38:33 +0400

> Fixed a typo in niu_determine_phy_disposition() which resulted in
> phy_template_1g_copper being selected for 10G/copper configuration.
> 
> Signed-off-by: Constantin Baranov <baranov@mercdev.com>

10g copper cards pretty much don't exist, which is probably why
nobody has hit this problem :-)

Patch applied, thanks.
