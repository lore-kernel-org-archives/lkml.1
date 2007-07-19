Return-Path: <linux-kernel-owner+w=401wt.eu-S1764276AbXGSVQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764276AbXGSVQX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 17:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759830AbXGSVQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 17:16:14 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37363
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1759461AbXGSVQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 17:16:13 -0400
Date: Thu, 19 Jul 2007 14:16:12 -0700 (PDT)
Message-Id: <20070719.141612.72713859.davem@davemloft.net>
To: nix.or.die@googlemail.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: net/ipv4/inetpeer.c stack warnings
From: David Miller <davem@davemloft.net>
In-Reply-To: <469F5941.7090900@googlemail.com>
References: <469F5941.7090900@googlemail.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gabriel C <nix.or.die@googlemail.com>
Date: Thu, 19 Jul 2007 14:29:53 +0200

> Hello ,
> 
> I noticed on current git this warning in net/ipv4/inetpeer.c
> 
> ...
> 
>   CC      net/ipv4/inetpeer.o
> net/ipv4/inetpeer.c: In function 'unlink_from_pool':
> net/ipv4/inetpeer.c:297: warning: the address of 'stack' will always
> evaluate as 'true'
> net/ipv4/inetpeer.c:297: warning: the address of 'stack' will always
> evaluate as 'true'
> net/ipv4/inetpeer.c: In function 'inet_getpeer':
> net/ipv4/inetpeer.c:409: warning: the address of 'stack' will always
> evaluate as 'true'
> net/ipv4/inetpeer.c:409: warning: the address of 'stack' will always
> evaluate as 'true'

The compiler should not warn about that at all, the lookup()
macro is called with "stack" set to NULL.
