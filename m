Return-Path: <linux-kernel-owner+w=401wt.eu-S1760873AbYGaDPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760873AbYGaDPg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 23:15:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754645AbYGaDP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 23:15:27 -0400
Received: from mail.fieldses.org ([66.93.2.214]:49767 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754513AbYGaDP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 23:15:26 -0400
Date: Wed, 30 Jul 2008 23:15:12 -0400
To: Michael Shuey <shuey@purdue.edu>
Cc: Shehjar Tikoo <shehjart@cse.unsw.edu.au>, linux-kernel@vger.kernel.org,
       linux-nfs@vger.kernel.org, rees@citi.umich.edu, aglo@citi.umich.edu
Subject: Re: high latency NFS
Message-ID: <20080731031512.GA26203@fieldses.org>
References: <200807241311.31457.shuey@purdue.edu> <20080730192110.GA17061@fieldses.org> <4890DFC7.3020309@cse.unsw.edu.au> <200807302235.50068.shuey@purdue.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807302235.50068.shuey@purdue.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2008 at 10:35:49PM -0400, Michael Shuey wrote:
> Thanks for all the tips I've received this evening.  However, I figured out 
> the problem late last night. :-)
> 
> I was only using the default 8 nfsd threads on the server.  When I raised 
> this to 256, the read bandwidth went from about 6 MB/sec to about 95 
> MB/sec, at 100ms of netem-induced latency.

So this is yet another reminder that someone needs to implement some
kind of automatic tuning of the number of threads.

I guess the first question is what exactly the policy for that should
be?  How do we decide when to add another thread?  How do we decide when
there are too many?

--b.
