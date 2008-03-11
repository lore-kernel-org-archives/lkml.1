Return-Path: <linux-kernel-owner+w=401wt.eu-S1756992AbYCKG5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756992AbYCKG5Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 02:57:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754048AbYCKG5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 02:57:16 -0400
Received: from relay1.sgi.com ([192.48.171.29]:51930 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753143AbYCKG5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 02:57:16 -0400
Date: Tue, 11 Mar 2008 01:57:11 -0500
From: Paul Jackson <pj@sgi.com>
To: maxk@qualcomm.com
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       menage@google.com
Subject: Re: [PATCH 1/2] cpuset: cpuset irq affinities
Message-Id: <20080311015711.9c4615a6.pj@sgi.com>
In-Reply-To: <1205215046-27085-2-git-send-email-maxk@qualcomm.com>
References: <1205215046-27085-1-git-send-email-maxk@qualcomm.com>
	<1205215046-27085-2-git-send-email-maxk@qualcomm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Max K wrote:
> this could also provide the desired semantics.

Could you spell out what you mean by "the desired semantics" ?

I don't see any Documentation or much comments, which would
help understand this.  It helps to describe both what has
changed, and, from the top, the why, what and how of what
you're doing, in part as Documentation or code comments,
for the benefit of future readers.

Did you see my discussion of this with Peter on March 6 and 7
in the lkml "[RFC/PATCH] cpuset: cpuset irq affinities" thread?
This latest patch of yours seems, offhand, to predate that discussion.

I don't see any explanation of what locking is needed when.

What semantics to you impose on irqs in overlapping cpusets,
which would seem to lead to conflicting directives as to
whether one set or another of irqs was to be applied to the
CPUs in the overlap?

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
