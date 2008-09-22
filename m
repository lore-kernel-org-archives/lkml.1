Return-Path: <linux-kernel-owner+w=401wt.eu-S1752833AbYIVMP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833AbYIVMP6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 08:15:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751909AbYIVMPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 08:15:51 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58467
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751904AbYIVMPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 08:15:50 -0400
Date: Mon, 22 Sep 2008 05:15:38 -0700 (PDT)
Message-Id: <20080922.051538.266960382.davem@davemloft.net>
To: alan@lxorguk.ukuu.org.uk
Cc: vcaputo@pengaru.com, linux-kernel@vger.kernel.org
Subject: Re: Honoring SO_RCVLOWAT in proto_ops.poll methods
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080921211337.74e8f1f1@lxorguk.ukuu.org.uk>
References: <20080921151811.46328133@lxorguk.ukuu.org.uk>
	<20080921145134.GT2761@fc6222126.aspadmin.net>
	<20080921211337.74e8f1f1@lxorguk.ukuu.org.uk>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Sun, 21 Sep 2008 21:13:37 +0100

> Thats a gloriously insane way of trying to do HTTP/1.1, and one I'm not
> sure is actually viable in the real world because the TCP window may be
> smaller than the number of bytes required to find a Host: header - so you
> may simply not be able to receive it via MSG_PEEK. In particular mobile
> phone gateways have a nasty habit of using very small windows.
> 
> > I just don't see a good solution for what I'm doing other than MSG_PEEK
> > and SO_RCVLOWAT, any ideas?
> 
> I don't either, and while I don't agree that what you are doing for
> HTTP/1.1 is remotely sane there are probably other cases this would be
> both sane and useful which does suggest fixing it would be beneficial

I agree and I'll try to move this forward.
