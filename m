Return-Path: <linux-kernel-owner+w=401wt.eu-S1756557AbYB0RJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557AbYB0RJ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 12:09:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751412AbYB0RJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 12:09:16 -0500
Received: from relay1.sgi.com ([192.48.171.29]:47102 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751061AbYB0RJP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 12:09:15 -0500
Date: Wed, 27 Feb 2008 11:09:12 -0600
From: Paul Jackson <pj@sgi.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: rientjes@google.com, clameter@sgi.com, ak@suse.de,
       linux-kernel@vger.kernel.org, mtk-manpages@gmx.net
Subject: Re: [patch 5/6] mempolicy: add MPOL_F_RELATIVE_NODES flag
Message-Id: <20080227110912.75d82710.pj@sgi.com>
In-Reply-To: <1204126666.5029.26.camel@localhost>
References: <alpine.DEB.1.00.0802250012420.12368@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0802250013580.12368@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0802250014170.12368@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0802250014410.12368@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0802250016120.12368@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0802261704310.25919@chino.kir.corp.google.com>
	<1204126666.5029.26.camel@localhost>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lee wrote:
> 1) this IS a change in behavior, right?  My first inclination is to shy
> away from this.  However, ...
> 
> 2) the current interaction of mempolicies with cpusets is not well
> documented--until Paul's cpuset.4 man page hits the streets, anyway.
> That doc does say that mempolicy is not allowed to use a node outside
> the cpuset.  It does NOT say how this is enforced--reject vs masking vs

We should strive to minimize change in existing behaviour, especially
on points where either way could be arguably a reasonable choice in
some situations, and neither way is a clearly inescapable bug in other
situations.

One almost always breaks someone, somewhere with such changes.  You
need a compelling reason to do that, not just a "on this hand, on that
hand" design choice.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
