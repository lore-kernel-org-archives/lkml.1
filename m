Return-Path: <linux-kernel-owner+w=401wt.eu-S1754702AbYD0FTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702AbYD0FTS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 01:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751785AbYD0FTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 01:19:10 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42525
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751594AbYD0FTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 01:19:09 -0400
Date: Sat, 26 Apr 2008 22:19:08 -0700 (PDT)
Message-Id: <20080426.221908.193700782.davem@davemloft.net>
To: viro@ZenIV.linux.org.uk
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       jgarzik@pobox.com
Subject: Re: [PATCH] e1000e triggers sparc32 gcc bug
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080427051541.GN5882@ZenIV.linux.org.uk>
References: <20080427051541.GN5882@ZenIV.linux.org.uk>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ZenIV.linux.org.uk>
Date: Sun, 27 Apr 2008 06:15:42 +0100

> 	... and isn't possible on sparc32 boxen anyway, unless somebody
> had done JavaStation with PCIE lately.
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Acked-by: David S. Miller <davem@davemloft.net>

Unfortunately this is necessary, every gcc I've tried triggers
a reload bug on 32-bit sparc.

Meanwhile I'll try and get the gcc bug fixed.

Thanks Al.

