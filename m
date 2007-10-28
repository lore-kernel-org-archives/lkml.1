Return-Path: <linux-kernel-owner+w=401wt.eu-S1752359AbXJ1NKN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752359AbXJ1NKN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 09:10:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754347AbXJ1NJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 09:09:46 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43276 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146AbXJ1NJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 09:09:45 -0400
Date: Sun, 28 Oct 2007 13:04:29 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-arch@vger.kernel.org,
       Joe Perches <joe@perches.com>, Alexey Dobriyan <adobriyan@gmail.com>,
       akpm@osdl.org, torvalds@osdl.org
Subject: Re: [PATCH] proc_fs.h redux
Message-ID: <20071028130429.GC12554@flint.arm.linux.org.uk>
Mail-Followup-To: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, linux-arch@vger.kernel.org,
	Joe Perches <joe@perches.com>,
	Alexey Dobriyan <adobriyan@gmail.com>, akpm@osdl.org,
	torvalds@osdl.org
References: <20071027194758.GD9816@martell.zuzino.mipt.ru> <1193524804.26695.103.camel@localhost> <20071028103415.GA12554@flint.arm.linux.org.uk> <20071028115952.GA18479@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071028115952.GA18479@suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 28, 2007 at 12:59:52PM +0100, Bernhard Walle wrote:
> * Russell King <rmk+lkml@arm.linux.org.uk> [2007-10-28 11:34]:
> > 
> > If you go down that route, you end up with _lots_ of circular
> > dependencies - header file X needs Y needs Z which needs X.  We've
> > been there, several times.  It very quickly becomes quite
> > unmaintainable - you end up with hard to predict behaviour from
> > include files.
> > 
> > The only realistic solution is to use forward declarations.
> 
> In header files, yes. But that's not true for implementation files.

I don't think that needs saying - it's quite obvious.  You can't
access the contents of structures without their definitions being
available.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
