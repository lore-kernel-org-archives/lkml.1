Return-Path: <linux-kernel-owner+w=401wt.eu-S1755267AbZD1JIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267AbZD1JIn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 05:08:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754157AbZD1JIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 05:08:31 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57406
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754081AbZD1JIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 05:08:31 -0400
Date: Tue, 28 Apr 2009 02:08:24 -0700 (PDT)
Message-Id: <20090428.020824.12093588.davem@davemloft.net>
To: hartleys@visionengravers.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net/ipv6/tcp_ipv6.c: fix sparse warnings
From: David Miller <davem@davemloft.net>
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE19090165F12C@mi8nycmail19.Mi8.com>
References: <BD79186B4FD85F4B8E60E381CAEE19090165F12C@mi8nycmail19.Mi8.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H Hartley Sweeten" <hartleys@visionengravers.com>
Date: Wed, 22 Apr 2009 20:35:39 -0400

> Fix the following sparse warnings in net/ipv6/tcp_ipv6.c.
> 
>   warning: symbol 'tcp6_gro_receive' was not declared. Should it be static?
>   warning: symbol 'tcp6_gro_complete' was not declared. Should it be static?
> 
> Both symbols are exported but not referenced anywhere outside of
> this source file. Remove the exports and make the functions static.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

1) Please post networking patches with netdev@vger.kernel.org
   at least CC:'d

2) Your email client corrupted this patch, making it not apply
   properly.

Please fix these details up and resubmit your patch, thanks!
