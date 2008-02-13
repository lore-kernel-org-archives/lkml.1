Return-Path: <linux-kernel-owner+w=401wt.eu-S1758829AbYBMIyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758829AbYBMIyT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 03:54:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753978AbYBMIyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 03:54:05 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53930
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752244AbYBMIyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 03:54:02 -0500
Date: Wed, 13 Feb 2008 00:54:33 -0800 (PST)
Message-Id: <20080213.005433.23276743.davem@davemloft.net>
To: sam@ravnborg.org
Cc: greg@kroah.com, torvalds@linux-foundation.org, jeff@garzik.org,
       arjan@infradead.org, sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org, linux-kbuild@vger.kernel.org
Subject: Re: distributed module configuration
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080213084541.GA8091@uranus.ravnborg.org>
References: <20080212191552.GA20883@kroah.com>
	<20080212.164149.209357519.davem@davemloft.net>
	<20080213084541.GA8091@uranus.ravnborg.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sam Ravnborg <sam@ravnborg.org>
Date: Wed, 13 Feb 2008 09:45:41 +0100

> So we could do:
> 
> config foo
> 	tristate "do you want foo?"
> 	depends on USB && BAR
> 	module
> 	  obj-$(CONFIG_FOO) += foo.o
> 	  foo-y := file1.o file2.o
> 	help
> 	  foo will allow you to explode your PC
 ...
> Does this fit what you had in mind?

Yes it does.

Now I'll ask if you think embedding this information in one of the C
files for a module would be even nicer?

Also, we need to make sure we can properly handle top-level
container-like items.  For example, where would menuconfigs like
NETDEV_10000 go if we adopt this kind of scheme?

