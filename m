Return-Path: <linux-kernel-owner+w=401wt.eu-S1754228AbYITWWD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228AbYITWWD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 18:22:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751796AbYITWVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 18:21:53 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44170
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751637AbYITWVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 18:21:53 -0400
Date: Sat, 20 Sep 2008 15:21:40 -0700 (PDT)
Message-Id: <20080920.152140.193698477.davem@davemloft.net>
To: lkml@pengaru.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: Honoring SO_RCVLOWAT in proto_ops.poll methods
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080920214229.GP2761@fc6222126.aspadmin.net>
References: <20080920214229.GP2761@fc6222126.aspadmin.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: lkml@pengaru.com
Date: Sat, 20 Sep 2008 16:42:29 -0500

> I have a need for select/poll/epoll_wait to block on sockets which have
> unread data sitting in the receive buffer with a quantity less than
> specified via setsockopt() w/SO_RCVLOWAT, not less than one like the
> current implementation.

If BSD never provided this behavior, such a change is likely
to break applications.
