Return-Path: <linux-kernel-owner+w=401wt.eu-S1763863AbYBZR4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763863AbYBZR4i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 12:56:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757942AbYBZR4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 12:56:30 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:52507 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753048AbYBZR43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 12:56:29 -0500
Date: Tue, 26 Feb 2008 11:56:27 -0600
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: akpm@linux-foundation.org, clameter@sgi.com, Lee.Schermerhorn@hp.com,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/6] mempolicy: add MPOL_F_STATIC_NODES flag
Message-Id: <20080226115627.681dafb9.pj@sgi.com>
In-Reply-To: <alpine.DEB.1.00.0802250014170.12368@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802250012420.12368@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0802250013580.12368@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0802250014170.12368@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>         return do_mbind(start, len, mode, mode_flags, &nodes, flags);

The intermingling of 'flags', 'mode' and 'mode_flags' to refer to the
low bits, the high bits or all the bits of the flags field is handled
fairly carefully in your patch, but can still be a bit difficult to
keep track of which is which when reading.

I'll wager not many readers can immediately say what the 'mode',
'mode_flags' and 'flags' refer to, in the above code snippet, for
example.

Do you have any suggestions on how to further improve the clarity of
this code?

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
