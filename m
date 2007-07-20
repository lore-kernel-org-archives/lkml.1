Return-Path: <linux-kernel-owner+w=401wt.eu-S965820AbXGTAxM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965820AbXGTAxM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 20:53:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939729AbXGTAwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 20:52:39 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42130
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S939749AbXGTAwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 20:52:38 -0400
Date: Thu, 19 Jul 2007 17:52:37 -0700 (PDT)
Message-Id: <20070719.175237.07458467.davem@davemloft.net>
To: shannon.nelson@intel.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, jeff@garzik.org,
       dan.j.williams@intel.com, christopher.leech@intel.com,
       peter.p.waskiewicz.jr@intel.com
Subject: Re: [PATCH 6/7] DCA: Add Direct Cache Access driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070720004517.13564.19649.stgit@localhost.localdomain>
References: <20070720004403.13564.14294.stgit@localhost.localdomain>
	<20070720004517.13564.19649.stgit@localhost.localdomain>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shannon Nelson <shannon.nelson@intel.com>
Date: Thu, 19 Jul 2007 17:45:17 -0700

> +static spinlock_t dca_lock;
 ...
> +	spin_lock_init(&dca_lock);

It's easier to use DEFINE_SPINLOCK().
