Return-Path: <linux-kernel-owner+w=401wt.eu-S1760757AbYFMAEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760757AbYFMAEj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 20:04:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757323AbYFMAEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 20:04:30 -0400
Received: from ik-out-1112.google.com ([66.249.90.181]:17437 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755781AbYFMAEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 20:04:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:x-x-sender:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type:from;
        b=K44bauQShT38BLMPbUBnSHSKIV0rvyYU2ZqIc+CenZkJNk7snWDi50TD2oVvzMftAx
         K+0aH+K4rcRteNo7W2SvNwuTvkN2XFVhsweNfc/1pHpyPLbsyMUv4COccCQqayqse2UY
         zuwnzibmi4K8LnYO9K71hxs+9zNZCzVKv5g1o=
Date: Fri, 13 Jun 2008 01:04:25 +0100 (BST)
X-X-Sender: bb3081@gamma
To: Daniel Walker <dwalker@mvista.com>
cc: Byron Bradley <byron.bbradley@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, linux-mm@kvack.org,
       Hua Zhong <hzhong@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.26-rc5-mm3
In-Reply-To: <1213314906.16459.90.camel@localhost.localdomain>
Message-ID: <alpine.DEB.1.00.0806130100300.14928@gamma>
References: <20080611225945.4da7bb7f.akpm@linux-foundation.org> <alpine.DEB.1.00.0806130006490.14928@gamma> <1213314906.16459.90.camel@localhost.localdomain>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
From: Byron Bradley <byron.bbradley@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jun 2008, Daniel Walker wrote:

> 
> On Fri, 2008-06-13 at 00:32 +0100, Byron Bradley wrote:
> > Looks like x86 and ARM both fail to boot if PROFILE_LIKELY, FTRACE and 
> > DYNAMIC_FTRACE are selected. If any one of those three are disabled it 
> > boots (or fails in some other way which I'm looking at now). The serial 
> > console output from both machines when they fail to boot is below, let me 
> > know if there is any other information I can provide.
> 
> Did you happen to check PROFILE_LIKELY and FTRACE alone?

Yes, without DYNAMIC_FTRACE the arm box gets all the way to userspace and 
the x86 box panics while registering a driver so most likely unrelated to 
this problem.

-- 
Byron Bradley
