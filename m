Return-Path: <linux-kernel-owner+w=401wt.eu-S1760821AbZFQXIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760821AbZFQXIr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 19:08:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753696AbZFQXIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 19:08:40 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36477
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755383AbZFQXIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 19:08:39 -0400
Date: Wed, 17 Jun 2009 16:08:40 -0700 (PDT)
Message-Id: <20090617.160840.58571632.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: rientjes@google.com, jpiszcz@lucidpixels.com, linux-kernel@vger.kernel.org
Subject: Re: [patch] ipv4: don't warn about skb ack allocation failures
From: David Miller <davem@davemloft.net>
In-Reply-To: <4A396EA2.60705@gmail.com>
References: <4A3957A1.5030407@gmail.com>
	<alpine.DEB.2.00.0906171401440.7198@chino.kir.corp.google.com>
	<4A396EA2.60705@gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Thu, 18 Jun 2009 00:30:58 +0200

> My point is that 99% of callers know allocation failures are
> recoverable.

I agree that, surely for GFP_ATOMIC, warnings should be off
by default.
