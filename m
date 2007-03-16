Return-Path: <linux-kernel-owner+w=401wt.eu-S965336AbXCPOuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965336AbXCPOuo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 10:50:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965351AbXCPOuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 10:50:44 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:41336 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965336AbXCPOun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 10:50:43 -0400
Date: Fri, 16 Mar 2007 20:27:49 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Paul Menage <menage@google.com>, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, xemul@sw.ru, pj@sgi.com,
       ebiederm@xmission.com, winget@google.com, containers@lists.osdl.org,
       akpm@linux-foundation.org
Subject: Re: Summary of resource management discussion
Message-ID: <20070316145749.GA4760@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070312124226.GD17151@in.ibm.com> <6599ad830703150424t3478cd55mf9d2699f3669c9f0@mail.gmail.com> <20070315170435.GA28692@in.ibm.com> <20070316141915.GA6572@MAIL.13thfloor.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070316141915.GA6572@MAIL.13thfloor.at>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2007 at 03:19:16PM +0100, Herbert Poetzl wrote:
> > Do you see any drawbacks of doing like this? What will break if we do
> > this?
> 
> looks good to me, except for the potential issue with
> the double indirection introducing too much overhear

Sure. I plan to get some numbers with and without the indirection in
nsproxy.

I was planning to get these numbers with a prelimnary CPU controller I wrote a 
while back (http://lkml.org/lkml/2006/9/28/236 and 
http://lkml.org/lkml/2007/1/26/12). Do you have plans to publish any CPU 
controller in the short term as well?

-- 
Regards,
vatsa
