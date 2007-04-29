Return-Path: <linux-kernel-owner+w=401wt.eu-S1754443AbXD2DYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443AbXD2DYa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 23:24:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754518AbXD2DYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 23:24:20 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56717
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754424AbXD2DX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 23:23:57 -0400
Date: Sat, 28 Apr 2007 20:24:05 -0700 (PDT)
Message-Id: <20070428.202405.14973612.davem@davemloft.net>
To: rdreier@cisco.com
Cc: alessandro.suardi@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [2.6.21-git2] sk_buff changes break Cisco VPN client
From: David Miller <davem@davemloft.net>
In-Reply-To: <ada647gmcq0.fsf@cisco.com>
References: <5a4c581d0704281338w28227b13p52f3043a56af4945@mail.gmail.com>
	<ada647gmcq0.fsf@cisco.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland Dreier <rdreier@cisco.com>
Date: Sat, 28 Apr 2007 14:05:27 -0700

> However I can suggest vpnc (http://www.unix-ag.uni-kl.de/~massar/vpnc/)
> as an alternative.  I'm not forced to use Cisco VPN access any more,
> but when I tried it, vpnc was tons better than the Cisco product.

Also, and I know this might be a COMPLETE SHOCK to some people, but we
do have a full in-kernel IPSEC stack and using it with openswan to
connect to VPNs works perfectly fine.

I use it every day.

It's quite amusing that people use a userland IPSEC implementation
via VPNC, in spite of this.
