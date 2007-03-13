Return-Path: <linux-kernel-owner+w=401wt.eu-S1753301AbXCMQQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301AbXCMQQ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 12:16:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753310AbXCMQQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 12:16:59 -0400
Received: from colin.muc.de ([193.149.48.1]:2468 "EHLO mail.muc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753301AbXCMQQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 12:16:58 -0400
Date: 13 Mar 2007 17:16:56 +0100
Date: Tue, 13 Mar 2007 17:16:56 +0100
From: Andi Kleen <ak@muc.de>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Linus Torvalds <torvalds@osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Dan Hecht <dhecht@vmware.com>,
       Dan Arai <arai@vmware.com>, Andrew Morton <akpm@osdl.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: [PATCH 2/9] Sched clock paravirt op fix.patch
Message-ID: <20070313161656.GA12128@muc.de>
References: <200703020254.l222sOaM009656@zach-dev.vmware.com> <20070313140129.GB92373@muc.de> <45F6C2A3.4040305@goop.org> <20070313160709.GH10574@sequoia.sous-sol.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070313160709.GH10574@sequoia.sous-sol.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2007 at 09:07:09AM -0700, Chris Wright wrote:
> * Jeremy Fitzhardinge (jeremy@goop.org) wrote:
> > In other words, regardless of whether this particular pv_op lives or
> > dies, we're going to need to have to deal with stolen time properly.  I
> > think this hook is reasonable and useful step towards doing that.
> 
> Exactly.  Normal interrupts we can handle.  Having CPU completely
> disappear for unkown time periods we can't, and will need to.

But that is just what a interrupt is.

-Andi
