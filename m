Return-Path: <linux-kernel-owner+w=401wt.eu-S1756633AbYGaJls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756633AbYGaJls (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 05:41:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755197AbYGaJk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 05:40:29 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42055
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753231AbYGaJk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 05:40:27 -0400
Date: Thu, 31 Jul 2008 02:40:27 -0700 (PDT)
Message-Id: <20080731.024027.162488608.davem@davemloft.net>
To: thomas.petazzoni@free-electrons.com
Cc: linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       michael@free-electrons.com
Subject: Re: [patch 0/4] [resend] Add configuration options to disable
 features not needed on embedded devices
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080731092703.661994657@free-electrons.com>
References: <20080731092703.661994657@free-electrons.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Date: Thu, 31 Jul 2008 11:27:03 +0200

> Changes since previous post:
> 
>  * Add Matt Mackall's Signed-off-by on all patches
>  * Make bonding and bridging select ethtool in the ethtool-related
>    patch.

The ethtool config option needs to be selected by CONFIG_INET as well,
as per the things I described today.  Which erodes it's usefulness
tremendously.

I also am keeping my stance that I have no current intention of
applying these patches.
