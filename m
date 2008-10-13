Return-Path: <linux-kernel-owner+w=401wt.eu-S1755901AbYJMHfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901AbYJMHfS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 03:35:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753502AbYJMHfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 03:35:06 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57829
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753247AbYJMHfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 03:35:05 -0400
Date: Mon, 13 Oct 2008 00:34:41 -0700 (PDT)
Message-Id: <20081013.003441.109866647.davem@davemloft.net>
To: swivel@shells.gnugeneration.com
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: Honoring SO_RCVLOWAT in proto_ops.poll methods
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081005.153059.111120997.davem@davemloft.net>
References: <20081005.132722.203253085.davem@davemloft.net>
	<20081005214556.GL18569@fc6222126.aspadmin.net>
	<20081005.153059.111120997.davem@davemloft.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Sun, 05 Oct 2008 15:30:59 -0700 (PDT)

> From: swivel@shells.gnugeneration.com
> Date: Sun, 5 Oct 2008 16:45:57 -0500
> 
> > I will be testing this patch today.  At a glance it appears with this
> > patch we're still not taking rcvlowat into consideration in recv()
> > with MSG_PEEK flag set.  This should probably also be corrected, as
> > mentioned in the thread previously.
> 
> Yes, I remember you mentioning that.
> 
> I'll look into it.

Were you able to test my updated patch?

If it makes your application work, I might want to defer messing around
with MSG_PEEK semantics in recvmsg().

So I've been waiting for your test results before I proceed.
