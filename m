Return-Path: <linux-kernel-owner+w=401wt.eu-S1762615AbYBEWPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762615AbYBEWPj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 17:15:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762136AbYBEWP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 17:15:27 -0500
Received: from relay1.sgi.com ([192.48.171.29]:57700 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762283AbYBEWPX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 17:15:23 -0500
Date: Tue, 5 Feb 2008 16:15:19 -0600
From: Paul Jackson <pj@sgi.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, clameter@sgi.com, rientjes@google.com,
       mel@csn.ul.ie, torvalds@linux-foundation.org, eric.whitney@hp.com
Subject: Re: [2.6.24 regression][BUGFIX] numactl --interleave=all doesn't
 works on memoryless node.
Message-Id: <20080205161519.b344dd08.pj@sgi.com>
In-Reply-To: <1202248652.5332.51.camel@localhost>
References: <20080202180536.F494.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<1202149243.5028.61.camel@localhost>
	<20080205163406.270B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<1202248652.5332.51.camel@localhost>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lee wrote:
> [PATCH] 2.6.24-mm1 - mempolicy:  silently restrict to allowed nodes

At first glance, I like it.  Thanks.

The changes in the exact behaviour of set_mempolicy (and mbind?) seem
to me to be changes for the better -- subtle improvements in the
consistency of handling corner cases.

However I don't have code that depends all that elaborately on the
fine details of these system calls, so I'm easy.  If others know of
an existing or likely usage pattern that this patch would break,
that would be interesting input.

Thanks, Lee.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
