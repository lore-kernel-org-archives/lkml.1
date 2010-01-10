Return-Path: <linux-kernel-owner+w=401wt.eu-S1753963Ab0AJV17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963Ab0AJV17 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 16:27:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753916Ab0AJV16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 16:27:58 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41887
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753308Ab0AJV16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 16:27:58 -0500
Date: Sun, 10 Jan 2010 13:28:06 -0800 (PST)
Message-Id: <20100110.132806.177106798.davem@davemloft.net>
To: jslaby@suse.cz
Cc: adobriyan@gmail.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       kuznet@ms2.inr.ac.ru, pekkas@netcore.fi, jmorris@namei.org,
       yoshfuji@linux-ipv6.org, kaber@trash.net, netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] NET: ipv6, remove unnecessary check
From: David Miller <davem@davemloft.net>
In-Reply-To: <1263120183-16365-1-git-send-email-jslaby@suse.cz>
References: <20100110103528.GA4769@x200>
	<1263120183-16365-1-git-send-email-jslaby@suse.cz>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>
Date: Sun, 10 Jan 2010 11:43:03 +0100

> Stanse found a potential null dereference in snmp6_unregister_dev.
> There is a check for idev being NULL, but it is dereferenced
> earlier. But idev cannot be NULL when passed to
> snmp6_unregister_dev, so remove the test.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>

Applied.
