Return-Path: <linux-kernel-owner+w=401wt.eu-S1754314AbXEBF3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314AbXEBF3e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 01:29:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754725AbXEBF3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 01:29:34 -0400
Received: from holomorphy.com ([66.93.40.71]:41989 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754314AbXEBF3e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 01:29:34 -0400
Date: Tue, 1 May 2007 22:30:02 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Ting Yang <tingy@cs.umass.edu>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [patch] CFS scheduler, -v8
Message-ID: <20070502053002.GT31925@holomorphy.com>
References: <20070501212223.GA29867@elte.hu> <4637FE0A.7090405@cs.umass.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4637FE0A.7090405@cs.umass.edu>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2007 at 10:57:14PM -0400, Ting Yang wrote:
>  Authors of this paper proposed a scheduler: Earlist Eligible Virtual 
> Deadline First (EEVDF). EEVDF uses exactly the same method as CFS to 
> track the execution of each running task. The only difference between 
> EEVDF and CFS is that EEVDF tries to _deadline_ fair while CFS is 
> _start-time_ fair. Scheduling based on deadline gives better reponse 
> time bound and seems to more fair.
>  In the following part of this email, I will try to explain the 
> similarities and differences between EEVDF and CFS. Hopefully, this 
> might provide you with some useful information w.r.t your current work 
> on CFS.

Any chance you could write a patch to convert CFS to EEVDF? People may
have an easier time understanding code than theoretical explanations.
(I guess I could do it if sufficiently pressed.)


-- wli
