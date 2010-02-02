Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879Ab0BBH5k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 02:57:40 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:34195 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755396Ab0BBH5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 02:57:37 -0500
Date: Tue, 2 Feb 2010 13:27:16 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Paul Turner <pjt@google.com>
Cc: Bharata B Rao <bharata.rao@gmail.com>, linux-kernel@vger.kernel.org,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pavel Emelyanov <xemul@openvz.org>,
       Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
       Chris Friesen <cfriesen@nortel.com>, Paul Menage <menage@google.com>,
       Mike Waychison <mikew@google.com>
Subject: Re: [RFC v5 PATCH 0/8] CFS Hard limits - v5
Message-ID: <20100202075716.GC17333@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20100105075703.GE27899@in.ibm.com> <loom.20100108T214459-933@post.gmane.org> <344eb09a1001281949p37cd6d1awbc561937fc8f04f5@mail.gmail.com> <ed628a921001282026p2f8d64c7u416e55e48a21ea79@mail.gmail.com> <20100201082150.GB686@in.ibm.com> <ed628a921002010304p40397558lf45f53daca97e879@mail.gmail.com> <ed628a921002011025i432465acl166b845607546a64@mail.gmail.com> <20100202041448.GA17333@in.ibm.com> <ed628a921002012313s622efd2eg9fa9243419de4863@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed628a921002012313s622efd2eg9fa9243419de4863@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 01, 2010 at 11:13:42PM -0800, Paul Turner wrote:
> 
> I'm really glad that we're having this discussion however it feels
> like we are rat-holing a little on the handling of slack?  As an issue

That's because runtime rebalancing was one of the main the issues you
brought up.

> it seems a non-starter since if necessary it can be scrubbed with the
> same overhead as the original proposal for period refresh (i.e. remove
> slack from each cpu).  There are also trivial faster ways to zero it
> without this O(n) overhead.
> 
> I feel it would be more productive to focus discussion on other areas
> of design such as load balancer interaction, distribution from global
> to local pools, entity placement and fairness on wakeup, etc.

Sure, as I said looking forward to your patches!
Discussions/reviews on those aspects were hardly forthcoming during
my earlier posts. Hopefully we will see more review/discussions in future.

> 
> > Regards,
> > Bharata.
> >
