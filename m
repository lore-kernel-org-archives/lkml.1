Return-Path: <linux-kernel-owner+w=401wt.eu-S1750913AbXBKVlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750913AbXBKVlr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 16:41:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750917AbXBKVlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 16:41:47 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52274
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750913AbXBKVlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 16:41:46 -0500
Date: Sun, 11 Feb 2007 13:41:45 -0800 (PST)
Message-Id: <20070211.134145.48809485.davem@davemloft.net>
To: hancockr@shaw.ca
Cc: linux-kernel@vger.kernel.org, lunz@falooley.org
Subject: Re: [PATCH] keep track of network interface renaming
From: David Miller <davem@davemloft.net>
In-Reply-To: <45CF6C6A.1090506@shaw.ca>
References: <fa.rECiNcG8qmgC5L7se1aXLWosf4E@ifi.uio.no>
	<fa./pMesnnnb80P5K2iQYUkxeYCpXA@ifi.uio.no>
	<45CF6C6A.1090506@shaw.ca>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Hancock <hancockr@shaw.ca>
Date: Sun, 11 Feb 2007 13:20:10 -0600

> Unfortunately that's not very practical if, as in this case, the 
> renaming is being done from an initramfs. Hiding this information as we 
> do now is rather user-hostile.

Perhaps you have a point, I'll think about this some more.

But on the other hand note that kernel log messages can scroll away
and get lost, so you cannot really rely upon them for gathering
information which is necessary for properly detecting devices
in userspace or anything like that.
