Return-Path: <linux-kernel-owner+w=401wt.eu-S1757993AbXKAWlc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757993AbXKAWlc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 18:41:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753989AbXKAWlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 18:41:24 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:32788
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753817AbXKAWlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 18:41:24 -0400
Date: Thu, 01 Nov 2007 15:41:23 -0700 (PDT)
Message-Id: <20071101.154123.102568743.davem@davemloft.net>
To: alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org
Subject: Re: [IRDA] IRNET: Fix build when TCGETS2 is defined.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071101223010.6780cc98@the-village.bc.nu>
References: <200711011959.lA1JxPWc003735@hera.kernel.org>
	<20071101223010.6780cc98@the-village.bc.nu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Thu, 1 Nov 2007 22:30:10 +0000

> NO NO NO NO NO NO NO

Glad that got your attention, finally...

> Line disciplines have no business touching termios ioctls. Especially
> wrongly. 
> 
> Nothing anywhere in the kernel but the core ioctl code should be
> processing TCGET/TCSET calls.
> 
> Just delete them. It will return -ENOIOCTLCMD and the core tty layer will
> process them.

Ok.
