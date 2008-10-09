Return-Path: <linux-kernel-owner+w=401wt.eu-S1757232AbYJIA33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757232AbYJIA33 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 20:29:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754724AbYJIA3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 20:29:22 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53932
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752818AbYJIA3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 20:29:21 -0400
Date: Wed, 08 Oct 2008 17:28:57 -0700 (PDT)
Message-Id: <20081008.172857.189321725.davem@davemloft.net>
To: eparis@redhat.com
Cc: kkeil@suse.de, isdn4linux@listserv.isdn4linux.de,
       linux-kernel@vger.kernel.org
Subject: Re: mISDN didn't define af_family_key_strings et al.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1223512049.2952.8.camel@localhost.localdomain>
References: <1223512049.2952.8.camel@localhost.localdomain>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Paris <eparis@redhat.com>
Date: Wed, 08 Oct 2008 20:27:29 -0400

> I see that recently AF_ISDN was added to the kernel but I don't see them
> having updated af_family_key_strings[] found in net/core/sock.c.  I'm
> adding a new one myself and caught a NULL entry toward the end of the
> array.  My assumption is that isdn is using the sk_lock-AF_MAX entry
> instead of their own.

This has been fixed in net-next-2.6 for a few weeks.

net/core/sock.c:
  "sk_lock-AF_RXRPC" , "sk_lock-AF_ISDN"     , "sk_lock-AF_PHONET"   ,
