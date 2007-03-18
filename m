Return-Path: <linux-kernel-owner+w=401wt.eu-S1752343AbXCRMIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343AbXCRMIS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 08:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752325AbXCRMIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 08:08:18 -0400
Received: from colin.muc.de ([193.149.48.1]:4636 "EHLO mail.muc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535AbXCRMIR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 08:08:17 -0400
Date: 18 Mar 2007 13:08:14 +0100
Date: Sun, 18 Mar 2007 13:08:14 +0100
From: Andi Kleen <ak@muc.de>
To: David Miller <davem@davemloft.net>
Cc: rusty@rustcorp.com.au, jeremy@goop.org, mingo@elte.hu,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       chrisw@sous-sol.org, zach@vmware.com, anthony@codemonkey.ws,
       torvalds@linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [patch 13/26] Xen-paravirt_ops: Consistently wrap paravirt ops callsites to make them patchable
Message-ID: <20070318120814.GA45869@muc.de>
References: <20070316.023331.59468179.davem@davemloft.net> <45FB005D.9060809@goop.org> <1174127638.8897.75.camel@localhost.localdomain> <20070318.003309.71088169.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070318.003309.71088169.davem@davemloft.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The idea is _NOT_ that you go look for references to the paravirt_ops
> members structure, that would be stupid and you wouldn't be able to
> use the most efficient addressing mode on a given cpu, you'd be
> patching up indirect calls and crap like that.  Just say no...

That wouldn't handle inlines though. At least some of the current
paravirtops like cli/sti are critical enough to require inlining.

-Andi
