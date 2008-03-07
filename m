Return-Path: <linux-kernel-owner+w=401wt.eu-S1761405AbYCGV5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761405AbYCGV5w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 16:57:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753262AbYCGV5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 16:57:45 -0500
Received: from relay1.sgi.com ([192.48.171.29]:45903 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753925AbYCGV5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 16:57:44 -0500
Date: Fri, 7 Mar 2008 15:57:42 -0600
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: Lee.Schermerhorn@hp.com, akpm@linux-foundation.org, clameter@sgi.com,
       ak@suse.de, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       eric.whitney@hp.com
Subject: Re: Regression:  Re: [patch -mm 2/4] mempolicy: create
 mempolicy_operations structure
Message-Id: <20080307155742.d7b54da6.pj@sgi.com>
In-Reply-To: <alpine.DEB.1.00.0803071341090.26765@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0803061135001.18590@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0803061135560.18590@chino.kir.corp.google.com>
	<1204922646.5340.73.camel@localhost>
	<alpine.DEB.1.00.0803071341090.26765@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David wrote:
> If you want to remove this requirement now (please get agreement from Paul)

I'm ducking and running for cover ;).

Personally, I'm slightly in favor of not requiring the empty mask,
as I always that that empty mask check was a couple lines of non-
essential logic.  However I'm slightly in favor of not changing
this detail from what it has been for years, which would mean we
still checked for the empty mask.  And no doubt, if someone cares
to examine the record closely enough they will find where I took a
third position as well.

But I can't see where it actually matters enough to write home about.

So I'll quit writing, and agree to most anything.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
