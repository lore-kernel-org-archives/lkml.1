Return-Path: <linux-kernel-owner+w=401wt.eu-S1764044AbXGJJGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764044AbXGJJGj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 05:06:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762325AbXGJJG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 05:06:27 -0400
Received: from waste.org ([66.93.16.53]:33102 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758777AbXGJJGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 05:06:25 -0400
Date: Tue, 10 Jul 2007 04:05:24 -0500
From: Matt Mackall <mpm@selenic.com>
To: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Keiichi Kii <k-keiichi@bx.jp.nec.com>, Netdev <netdev@vger.kernel.org>,
       Joel Becker <joel.becker@oracle.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH v2 -mm 2/9] netconsole: Remove bogus check
Message-ID: <20070710090524.GK11115@waste.org>
References: <20070710091920.23907.96483.sendpatchset@cselinux1.cse.iitk.ac.in> <20070710091930.23907.24600.sendpatchset@cselinux1.cse.iitk.ac.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070710091930.23907.24600.sendpatchset@cselinux1.cse.iitk.ac.in>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2007 at 02:49:30PM +0530, Satyam Sharma wrote:
> From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
> 
> [2/9] netconsole: Remove bogus check
> 
> The (!np.dev) check in write_msg() is bogus (always false), because:
> np.dev is set by netpoll_setup(), which is called by the target init
> code in init_netconsole() _before_ register_console() => write_msg() cannot
> be triggered unless netpoll_setup() returns with success. And that will not
> happen if netpoll_setup() failed to set np.dev. Also np.dev cannot go from
> under us while netconsole is loaded. This is because netpoll_setup() grabs
> a reference for us on that dev. So let's remove the pointless check.
> 
> Signed-off-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>
> Cc: Keiichi Kii <k-keiichi@bx.jp.nec.com>

Acked-by: Matt Mackall <mpm@selenic.com>

-- 
Mathematics is the supreme nostalgia of our time.
