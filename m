Return-Path: <linux-kernel-owner+w=401wt.eu-S1753257AbXCRRER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257AbXCRRER (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 13:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753261AbXCRRER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 13:04:17 -0400
Received: from colin.muc.de ([193.149.48.1]:3879 "EHLO mail.muc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753257AbXCRREQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 13:04:16 -0400
Date: 18 Mar 2007 18:04:14 +0100
Date: Sun, 18 Mar 2007 18:04:14 +0100
From: Andi Kleen <ak@muc.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: David Miller <davem@davemloft.net>, rusty@rustcorp.com.au, mingo@elte.hu,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       chrisw@sous-sol.org, zach@vmware.com, anthony@codemonkey.ws,
       torvalds@linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [patch 13/26] Xen-paravirt_ops: Consistently wrap paravirt ops callsites to make them patchable
Message-ID: <20070318170414.GB45869@muc.de>
References: <20070316.023331.59468179.davem@davemloft.net> <45FB005D.9060809@goop.org> <1174127638.8897.75.camel@localhost.localdomain> <20070318.003309.71088169.davem@davemloft.net> <20070318120814.GA45869@muc.de> <45FD619D.6030402@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45FD619D.6030402@goop.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The bigger problem is that you don't know what registers you can
> clobber.  For the pv_ops in hand-written asm, that a big pain.  The code
> either has to assume the worst, or the "relocator" has to do something
> more sophisticated (like look for push/pop pairs surrounding the call,
> perhaps?).

You could use the dwarf2 unwind tables. They have exact information
what register has what. But it would likely get complicated.

-Andi
