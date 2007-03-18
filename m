Return-Path: <linux-kernel-owner+w=401wt.eu-S1752684AbXCRR3M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684AbXCRR3M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 13:29:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752671AbXCRR3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 13:29:12 -0400
Received: from gw.goop.org ([64.81.55.164]:38440 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752676AbXCRR3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 13:29:11 -0400
Message-ID: <45FD76E6.4060907@goop.org>
Date: Sun, 18 Mar 2007 10:29:10 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@muc.de>
CC: David Miller <davem@davemloft.net>, rusty@rustcorp.com.au, mingo@elte.hu,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       chrisw@sous-sol.org, zach@vmware.com, anthony@codemonkey.ws,
       torvalds@linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [patch 13/26] Xen-paravirt_ops: Consistently wrap paravirt ops
 callsites to make them patchable
References: <20070316.023331.59468179.davem@davemloft.net> <45FB005D.9060809@goop.org> <1174127638.8897.75.camel@localhost.localdomain> <20070318.003309.71088169.davem@davemloft.net> <20070318120814.GA45869@muc.de> <45FD619D.6030402@goop.org> <20070318170414.GB45869@muc.de>
In-Reply-To: <20070318170414.GB45869@muc.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> You could use the dwarf2 unwind tables. They have exact information
> what register has what. But it would likely get complicated.

Yes.  And would they be accurate for hand-written asm, which is where we
have this problem?

    J
