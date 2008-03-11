Return-Path: <linux-kernel-owner+w=401wt.eu-S1754730AbYCKTJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730AbYCKTJR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 15:09:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752702AbYCKTJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 15:09:03 -0400
Received: from relay1.sgi.com ([192.48.171.29]:49894 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751625AbYCKTJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 15:09:03 -0400
Date: Tue, 11 Mar 2008 14:08:58 -0500
From: Paul Jackson <pj@sgi.com>
To: Max Krasnyansky <maxk@qualcomm.com>
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       menage@google.com
Subject: Re: [PATCH 1/2] cpuset: cpuset irq affinities
Message-Id: <20080311140858.d0ecd47f.pj@sgi.com>
In-Reply-To: <47D6C08E.9040701@qualcomm.com>
References: <1205215046-27085-1-git-send-email-maxk@qualcomm.com>
	<1205215046-27085-2-git-send-email-maxk@qualcomm.com>
	<20080311015711.9c4615a6.pj@sgi.com>
	<47D6C08E.9040701@qualcomm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Max wrote:
> Please take a look at
> 	[PATCH 2/2] cpusets: Improved irq affinity handling
> I'm treating irqs just like tasks (at least I think I'm :).

Well, I see the one comment in your Patch 2/2 noting you're unsure
of the locking in one place.

I don't see any further comments on or additional code involving
locking.

I don't see where you respond to my discussion with Peter of March
6 and 7, where I expressed some doubts about Peters patch (which you
built on in your patch 1/2 in this series).

I see only a little bit of additional comments in your patch 2/2
regarding handling of moving irqs to higher non-empty cpusets if a
cpuset is emptied of its CPUs.

I don't see any explanation of what you mean by "desired semantics."

I don't see any response to the alternatives to Peter's earlier patch
(your Patch 1/2 here) that Peter and I discussed in that discussion of
March 6 and 7.

And, in particular, could you respond to the question in my last
message:

> What semantics to you impose on irqs in overlapping cpusets,
> which would seem to lead to conflicting directives as to
> whether one set or another of irqs was to be applied to the
> CPUs in the overlap?

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
