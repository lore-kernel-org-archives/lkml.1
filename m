Return-Path: <linux-kernel-owner+w=401wt.eu-S1758093AbYJPWhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758093AbYJPWhj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 18:37:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757228AbYJPWhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 18:37:06 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37036
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757917AbYJPWhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 18:37:04 -0400
Date: Thu, 16 Oct 2008 15:36:41 -0700 (PDT)
Message-Id: <20081016.153641.32547403.davem@davemloft.net>
To: avorontsov@ru.mvista.com
Cc: linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net,
       sfalco@harris.com, grant.likely@secretlab.ca, khali@linux-fr.org,
       i2c@lm-sensors.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 1/7] powerpc and sparc: introduce dev_archdata node
 accessors
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081016171251.GA5515@oksana.dev.rtsoft.ru>
References: <20081016171222.GA24812@oksana.dev.rtsoft.ru>
	<20081016171251.GA5515@oksana.dev.rtsoft.ru>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Vorontsov <avorontsov@ru.mvista.com>
Date: Thu, 16 Oct 2008 21:12:51 +0400

> The name of the device_node field differ across the platforms, so we
> have to implement inlined accessors. This is needed to avoid ugly
> #ifdef in the generic code.
> 
> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>

I'm happy to just change this member name on sparc to match
powerpc's choice.

That being said, this abstraction still has value and I'd
like to let you merge this now and make forward progress
so:

Acked-by: David S. Miller <davem@davemloft.net>
