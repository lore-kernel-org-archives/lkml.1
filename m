Return-Path: <linux-kernel-owner+w=401wt.eu-S1755307AbYFDAt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307AbYFDAt5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 20:49:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752983AbYFDAtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 20:49:47 -0400
Received: from relay2.sgi.com ([192.48.171.30]:51430 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752896AbYFDAtr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 20:49:47 -0400
Date: Tue, 3 Jun 2008 19:49:42 -0500
From: Paul Jackson <pj@sgi.com>
To: Max Krasnyansky <maxk@qualcomm.com>
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       menage@google.com, rostedt@goodmis.org, maxk@qualcomm.com
Subject: Re: [PATCH] sched: Give cpusets exclusive control over sched
 domains (ie remove cpu_isolated_map)
Message-Id: <20080603194942.e1b904bd.pj@sgi.com>
In-Reply-To: <1212085023-22284-3-git-send-email-maxk@qualcomm.com>
References: <1212085023-22284-1-git-send-email-maxk@qualcomm.com>
	<1212085023-22284-2-git-send-email-maxk@qualcomm.com>
	<1212085023-22284-3-git-send-email-maxk@qualcomm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'll NAQ this one.

As a result of the separate lkml thread:

  Inquiry: Should we remove "isolcpus= kernel boot option? (may have realtime uses)

and as a result of there not yet being a good reason -to- remove this,
other than a few kernel developers who don't like it, I conclude that
we should not just remove the "isolcpus=" feature.

It might be that we should deprecate it, as I have suggested in the
past.  But I'm not now seeing even a good reason for that.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
