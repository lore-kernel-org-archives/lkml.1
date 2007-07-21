Return-Path: <linux-kernel-owner+w=401wt.eu-S935133AbXGUCji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935133AbXGUCji (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 22:39:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760082AbXGUCj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 22:39:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:32934
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1759062AbXGUCj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 22:39:27 -0400
Date: Fri, 20 Jul 2007 19:39:26 -0700 (PDT)
Message-Id: <20070720.193926.92584343.davem@davemloft.net>
To: kaber@trash.net
Cc: nix.or.die@googlemail.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: net/ipv4/inetpeer.c stack warnings
From: David Miller <davem@davemloft.net>
In-Reply-To: <469F5DBB.3080106@trash.net>
References: <469F5941.7090900@googlemail.com>
	<469F5DBB.3080106@trash.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrick McHardy <kaber@trash.net>
Date: Thu, 19 Jul 2007 14:48:59 +0200

> Gabriel C wrote:
> > Hello ,
> >
> > I noticed on current git this warning in net/ipv4/inetpeer.c
> 
> Yeah, I have no idea why the gcc people thought that this was
> something worth warning about. Especially since explicitly
> checking for != NULL silences the warning again.

Sigh, applied :-)
