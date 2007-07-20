Return-Path: <linux-kernel-owner+w=401wt.eu-S1761914AbXGTAw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761914AbXGTAw1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 20:52:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939339AbXGTAvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 20:51:11 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42124
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S939448AbXGTAvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 20:51:09 -0400
Date: Thu, 19 Jul 2007 17:51:08 -0700 (PDT)
Message-Id: <20070719.175108.95058293.davem@davemloft.net>
To: shannon.nelson@intel.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, jeff@garzik.org,
       dan.j.williams@intel.com, christopher.leech@intel.com,
       peter.p.waskiewicz.jr@intel.com
Subject: Re: [PATCH 5/7] I/OAT: Add support for MSI and MSI-X
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070720004512.13564.55742.stgit@localhost.localdomain>
References: <20070720004403.13564.14294.stgit@localhost.localdomain>
	<20070720004512.13564.55742.stgit@localhost.localdomain>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shannon Nelson <shannon.nelson@intel.com>
Date: Thu, 19 Jul 2007 17:45:12 -0700

> Add support for MSI and MSI-X interrupt handling, including the ability
> to choose the desired interrupt method.
> 
> Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>

Acked-by: David S. Miller <davem@davemloft.net>

But:

> +#define for_each_bit(bit, addr, size) \
> +	for ((bit) = find_first_bit((addr), (size)); \
> +	     (bit) < (size); \
> +	     (bit) = find_next_bit((addr), (size), (bit) + 1))

This or something like it is codified in a few spots now,
namely now here and cpumask.h, it would be nice to have
this in some standard place.
