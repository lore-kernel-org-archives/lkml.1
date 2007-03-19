Return-Path: <linux-kernel-owner+w=401wt.eu-S1030573AbXCSSmH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030573AbXCSSmH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 14:42:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030582AbXCSSmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 14:42:06 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:35592 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030580AbXCSSmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 14:42:05 -0400
Date: Mon, 19 Mar 2007 11:41:37 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@muc.de>,
       David Miller <davem@davemloft.net>, jeremy@goop.org, mingo@elte.hu,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       chrisw@sous-sol.org, zach@vmware.com, anthony@codemonkey.ws,
       torvalds@linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [patch 13/26] Xen-paravirt_ops: Consistently wrap paravirt ops callsites to make them patchable
Message-ID: <20070319184137.GB10574@sequoia.sous-sol.org>
References: <20070316.023331.59468179.davem@davemloft.net> <45FB005D.9060809@goop.org> <1174127638.8897.75.camel@localhost.localdomain> <20070318.003309.71088169.davem@davemloft.net> <20070318120814.GA45869@muc.de> <1174272469.11680.23.camel@localhost.localdomain> <m1648xxf93.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1648xxf93.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Eric W. Biederman (ebiederm@xmission.com) wrote:
> Is it truly critical to inline any of these instructions?

I don't have any current measurements.  But we'd been aiming
at getting irq_{en,dis}able to a simple memory write to pda.
But simplicity, maintenance, etc. win over trimming a couple
cycles, so still worth real look.

thanks,
-chris
