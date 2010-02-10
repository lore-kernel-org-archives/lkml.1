Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511Ab0BJHEN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 02:04:13 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39461
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751154Ab0BJHEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 02:04:11 -0500
Date: Tue, 09 Feb 2010 23:04:26 -0800 (PST)
Message-Id: <20100209.230426.65176612.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: tiago.maluta@gmail.com, linux-net@vger.kernel.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC][PATCH] Allow change timing values to wait slow devices
 bring up before try register an interface to IP-Config
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100209215120.ac46ff7c.akpm@linux-foundation.org>
References: <600adaf51002091947ta095cc5g7174684f57488e94@mail.gmail.com>
	<20100209215120.ac46ff7c.akpm@linux-foundation.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 9 Feb 2010 21:51:20 -0800

> Using delays was dumb of us, but I guess the problem is difficult.
> 
> It would be much better to configure this delay at runtime rather than
> at compile time.  Perhaps with new kernel boot parameters, perhaps by
> extending the ip= argument.

Old topic, see the thread at:

http://marc.info/?l=linux-netdev&m=126311212608318&w=2

I would prefer to just jack up the defaults a bit.

My opinion is that just about any larger default value is reasonable,
because if you enable IP autoconfig on the command line, you expect
the link and device to be there and waiting a few extra seconds won't
bother you.
