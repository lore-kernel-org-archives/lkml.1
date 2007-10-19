Return-Path: <linux-kernel-owner+w=401wt.eu-S935235AbXJSEz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935235AbXJSEz2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 00:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756568AbXJSEzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 00:55:10 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53007
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756136AbXJSEzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 00:55:08 -0400
Date: Thu, 18 Oct 2007 21:55:21 -0700 (PDT)
Message-Id: <20071018.215521.28810637.davem@davemloft.net>
To: olof@lixom.net
Cc: xemul@openvz.org, netdev@vger.kernel.org, devel@openvz.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] Fix race between sk_filter reassign and sk_clone()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071019022947.GA29560@lixom.net>
References: <4715D9D2.8070102@openvz.org>
	<20071017.212302.68039057.davem@davemloft.net>
	<20071019022947.GA29560@lixom.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Olof Johansson <olof@lixom.net>
Date: Thu, 18 Oct 2007 21:29:47 -0500

> So, looks like rcu_dereference() returned NULL. I don't know the
> filter code at all, but it seems like it might be a valid case?
> sk_detach_filter() seems to handle a NULL sk_filter, at least.
> 
> 
> So, this needs review by someone who knows the filter, but it fixes the
> problem for me:
> 
> 
> Signed-off-by: Olof Johansson <olof@lixom.net>

I've applied this for now to my net-2.6 tree, thanks Olof
for tracking this down.

Pavel please take a look at this and let me know if it should
fixed in some other way.

Thanks!
