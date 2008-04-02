Return-Path: <linux-kernel-owner+w=401wt.eu-S1759952AbYDBHAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759952AbYDBHAT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 03:00:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756596AbYDBHAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 03:00:07 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47893
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756094AbYDBHAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 03:00:06 -0400
Date: Wed, 02 Apr 2008 00:00:06 -0700 (PDT)
Message-Id: <20080402.000006.218698845.davem@davemloft.net>
To: hidave.darkstar@gmail.com
Cc: davej@codemonkey.org.uk, netdev@vger.kernel.org,
       linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
       marcel@holtmann.org
Subject: Re: [PATCH 1/2] bluetooth : use lockdep sub-classes for diffrent
 bluetooth protocol
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080402055956.GA3050@darkstar.te-china.tietoenator.com>
References: <20080402055956.GA3050@darkstar.te-china.tietoenator.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Young <hidave.darkstar@gmail.com>
Date: Wed, 2 Apr 2008 13:59:56 +0800

> 'rfcomm connect' will trigger lockdep warnings which is caused by
> locking diffrent kinds of bluetooth sockets at the same time.
> 
> So using sub-classes per AF_BLUETOOTH sub-type for lockdep.
> 
> Thanks for the hints from dave jones.

Applied, thanks for following up on this Dave.
