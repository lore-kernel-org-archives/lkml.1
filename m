Return-Path: <linux-kernel-owner+w=401wt.eu-S1763716AbZD3Qja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763716AbZD3Qja (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 12:39:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755806AbZD3QjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 12:39:16 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47315
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753534AbZD3QjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 12:39:15 -0400
Date: Thu, 30 Apr 2009 09:39:09 -0700 (PDT)
Message-Id: <20090430.093909.157285653.davem@davemloft.net>
To: panther@balabit.hu
Cc: kaber@trash.net, mingo@elte.hu, netdev@vger.kernel.org,
       netfilter-devel@vger.kernel.org, hidden@sch.bme.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xt_socket: checks for the state of nf_conntrack
From: David Miller <davem@davemloft.net>
In-Reply-To: <1241105755-10017-1-git-send-email-panther@balabit.hu>
References: <1241105755-10017-1-git-send-email-panther@balabit.hu>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laszlo Attila Toth <panther@balabit.hu>
Date: Thu, 30 Apr 2009 17:35:55 +0200

> xt_socket can use connection tracking, and checks whether it is a module.
> 
> Signed-off-by: Laszlo Attila Toth <panther@balabit.hu>

I don't understand why we want what this is doing....

> +	depends on !NF_CONNTRACK || NF_CONNTRACK

This means that if NF_CONNTRACK is modular, it won't allow
the xt_socket code to be built.

However, all of this stuff should be buildable modular.
