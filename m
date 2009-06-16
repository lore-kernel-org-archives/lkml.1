Return-Path: <linux-kernel-owner+w=401wt.eu-S1754367AbZFPJVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367AbZFPJVi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 05:21:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750961AbZFPJV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 05:21:29 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40473
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751321AbZFPJV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 05:21:28 -0400
Date: Tue, 16 Jun 2009 02:21:31 -0700 (PDT)
Message-Id: <20090616.022131.267374816.davem@davemloft.net>
To: mingo@elte.hu
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090616091538.GA4184@elte.hu>
References: <20090615.050449.144947903.davem@davemloft.net>
	<20090616091538.GA4184@elte.hu>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 16 Jun 2009 11:15:38 +0200

> BUG: sleeping function called from invalid context at net/core/sock.c:1851

This line in my tree (and Linus's) reads:

	if (sk->sk_lock.owned)

what gives? :-)
