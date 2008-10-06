Return-Path: <linux-kernel-owner+w=401wt.eu-S1754987AbYJFRqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987AbYJFRqd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 13:46:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752978AbYJFRqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 13:46:23 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40648
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752879AbYJFRqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 13:46:22 -0400
Date: Mon, 06 Oct 2008 10:45:52 -0700 (PDT)
Message-Id: <20081006.104552.13565146.davem@davemloft.net>
To: lkml@pengaru.com
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: Honoring SO_RCVLOWAT in proto_ops.poll methods
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081006.101814.193697461.davem@davemloft.net>
References: <20081005.153059.111120997.davem@davemloft.net>
	<20081006051718.GA2811@fc6222126.aspadmin.net>
	<20081006.101814.193697461.davem@davemloft.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Mon, 06 Oct 2008 10:18:14 -0700 (PDT)

> From: lkml@pengaru.com
> Date: Mon, 6 Oct 2008 00:17:18 -0500
> 
> > Looks like the RCVLOWAT patch breaks the tcp poll logic in the normal
> > case.
> 
> Sorry, the condition was reversed, try this one instead:

FWIW, since this passed my own testing, I pushed this into
net-next-2.6
