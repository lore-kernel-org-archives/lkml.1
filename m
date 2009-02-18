Return-Path: <linux-kernel-owner+w=401wt.eu-S1755501AbZBRWO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501AbZBRWO7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 17:14:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752061AbZBRWOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 17:14:48 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52880
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751877AbZBRWOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 17:14:47 -0500
Date: Wed, 18 Feb 2009 14:14:31 -0800 (PST)
Message-Id: <20090218.141431.103832064.davem@davemloft.net>
To: vladislav.yasevich@hp.com
Cc: chuck.lever@oracle.com, tytso@mit.edu, Valdis.Kletnieks@vt.edu,
       arvidjaar@mail.ru, rjw@sisk.pl, netdev@vger.kernel.org,
       bonding-devel@lists.sourceforge.net, jamagallon@ono.com,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.29 regression? Bonding tied to IPV6 in 29-rc5
From: David Miller <davem@davemloft.net>
In-Reply-To: <499C5486.5020807@hp.com>
References: <20090218135537.GF3600@mini-me.lan>
	<06F54D7E-EE07-49C9-AD8F-B46BD6B02ABA@oracle.com>
	<499C5486.5020807@hp.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Wed, 18 Feb 2009 13:33:42 -0500

> Would a module parameter that disables ipv6 or at least addrconf be
> enough of a solution?

We have it, it's just that (as others have stated) it doesn't
prevent IPV6 sockets from being openned by applications.
