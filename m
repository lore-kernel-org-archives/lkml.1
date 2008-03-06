Return-Path: <linux-kernel-owner+w=401wt.eu-S935972AbYCFVCI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935972AbYCFVCI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 16:02:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765504AbYCFVBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 16:01:53 -0500
Received: from relay1.sgi.com ([192.48.171.29]:59168 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759431AbYCFVBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 16:01:52 -0500
Date: Thu, 6 Mar 2008 15:01:48 -0600
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: akpm@linux-foundation.org, clameter@sgi.com, Lee.Schermerhorn@hp.com,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch -mm 4/4] mempolicy: remove includes for duplicate
 headers
Message-Id: <20080306150148.2aa87468.pj@sgi.com>
In-Reply-To: <alpine.DEB.1.00.0803061244560.31802@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0803061135001.18590@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0803061135560.18590@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0803061136160.18590@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0803061136320.18590@chino.kir.corp.google.com>
	<20080306141923.45ce4214.pj@sgi.com>
	<alpine.DEB.1.00.0803061244560.31802@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David wrote:
> It simply decreases the remote chance later that ...
> 
> The only way this would make things more fragile is if ...

Does anyone lurking on this thread know if there is an
established convention in kernel code, whether to directly
include all headers that your code explicitly needs, or
whether it's ok to rely on indirect includes for such?

David and I could debate the fine points of which way is
best until the cows come home; the two of us are good at
that.  This is too minor an issue for that sort of effort.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
