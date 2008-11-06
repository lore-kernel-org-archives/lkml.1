Return-Path: <linux-kernel-owner+w=401wt.eu-S1753569AbYKFGkB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569AbYKFGkB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 01:40:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753854AbYKFGjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 01:39:44 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35264
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753824AbYKFGjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 01:39:43 -0500
Date: Wed, 05 Nov 2008 22:39:42 -0800 (PST)
Message-Id: <20081105.223942.258207193.davem@davemloft.net>
To: greg@kroah.com
Cc: sfr@canb.auug.org.au, linux-kernel@vger.kernel.org, wli@holomorphy.com,
       sparclinux@vger.kernel.org
Subject: Re: sparc/staging compile error
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081106063709.GB7728@kroah.com>
References: <20081106163626.2306ad75.sfr@canb.auug.org.au>
	<20081106063709.GB7728@kroah.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <greg@kroah.com>
Date: Wed, 5 Nov 2008 22:37:09 -0800

> On Thu, Nov 06, 2008 at 04:36:26PM +1100, Stephen Rothwell wrote:
> > Hi Greg,
> > 
> > Today's tree from Linus gets the following error from a sparc
> > allmodconfig build:
> > 
> > ERROR: "___f_flush_cache_range" [drivers/staging/poch/poch.ko] undefined!
> 
> Odd, is flush_cache_range() not allowed on the sparc platform?

No, just nobody used it from a module before.
