Return-Path: <linux-kernel-owner+w=401wt.eu-S1756940AbYE2UvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756940AbYE2UvS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 16:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752989AbYE2UvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 16:51:00 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38429
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751065AbYE2Uu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 16:50:59 -0400
Date: Thu, 29 May 2008 13:50:55 -0700 (PDT)
Message-Id: <20080529.135055.193706538.davem@davemloft.net>
To: jimi@sngx.net
Cc: alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net: add ability to clear stats via ethtool -
 e1000/pcnet32
From: David Miller <davem@davemloft.net>
In-Reply-To: <483EE4A4.20508@sngx.net>
References: <483EA2D1.8050603@sngx.net>
	<20080529154525.3916c7b5@core>
	<483EE4A4.20508@sngx.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Cammarata <jimi@sngx.net>
Date: Thu, 29 May 2008 12:15:16 -0500

>  I'd be more than happy to change this to a kernel config
> option, experimental and default off for those who would not want it.

We never add pieces of code which are marked experimental and
intended to be marked that way forever, that's nonsense.

What you want is your little special kernel hack in the upstream
tree, and that's now how we handle such things, sorry.

I also agree with Alan that the kernel is the wrong place to
handle this problem.  Do it in userspace.

We have consistent precedence for this elsewhere in the kernel tree,
and there is good reason for that.
