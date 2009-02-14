Return-Path: <linux-kernel-owner+w=401wt.eu-S1754666AbZBNVjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666AbZBNVjY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 16:39:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754045AbZBNViv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 16:38:51 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:49450 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081AbZBNVit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 16:38:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Kwp8oJlCgc36P4QavXUG9J5vEf+0i8sYlFHBWSZAclGwpFT4vN4GQ/PRwjyJiAcj7u
         30L/gdu4aefPQ6nY3QBMfkMYuXLsqx1Q5ozl3ct2EJFP3ZtpruYAZt7/QGfOIL+zKVBe
         i2nLoKa5rUlNFdFVFZdiUDyaXVt+Wir/4+dRk=
Date: Sun, 15 Feb 2009 00:38:48 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Hannes Eder <hannes@hanneseder.net>, netdev@vger.kernel.org,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/43] drivers/net/ppp*.c: fix sparse warnings: fix
	signedness
Message-ID: <20090214213848.GF7648@localhost>
References: <20090214210940.23489.95001.stgit@vmbox.hanneseder.net> <20090214211346.23489.96321.stgit@vmbox.hanneseder.net> <20090214212948.GE7648@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090214212948.GE7648@localhost>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Sun, Feb 15, 2009 at 12:29:48AM +0300]
| [Hannes Eder - Sat, Feb 14, 2009 at 10:13:52PM +0100]
| | Fix this sparse warnings:
| |   drivers/net/ppp_generic.c:919:43: warning: incorrect type in argument 1 (different signedness)
| |   drivers/net/pppoe.c:1195:43: warning: incorrect type in argument 1 (different signedness)
| |   drivers/net/pppol2tp.c:2666:43: warning: incorrect type in argument 1 (different signedness)
| | 
| | Signed-off-by: Hannes Eder <hannes@hanneseder.net>
| ...
| 
| Thanks Hannes,
| 
| Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
| 
| 	- Cyrill -

Btw I think the same fix could be applied on
drivers/net/tun.c (if you have time for :)

	- Cyrill -
