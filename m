Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935818Ab0BZJyF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 04:54:05 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55004
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935745Ab0BZJyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 04:54:02 -0500
Date: Fri, 26 Feb 2010 01:54:20 -0800 (PST)
Message-Id: <20100226.015420.66646406.davem@davemloft.net>
To: error27@gmail.com
Cc: grant.likely@secretlab.ca, jeremy.kerr@canonical.com,
       afleming@freescale.com, jezz@sysmic.org,
       devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] of: check for IS_ERR()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100226094941.GE4912@bicker>
References: <20100226094941.GE4912@bicker>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <error27@gmail.com>
Date: Fri, 26 Feb 2010 12:49:41 +0300

> get_phy_device() can return an ERR_PTR()
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> ---
> I don't have a cross compile environment set up so I can't even compile 
> test this.  :/  But err.h is included so it should be OK.

It should return ERR_PTR() consistently.  Checking for both
NULL and ERR_PTR() is undesirable.
