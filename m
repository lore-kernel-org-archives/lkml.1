Return-Path: <linux-kernel-owner+w=401wt.eu-S1765896AbYCELHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765896AbYCELHy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 06:07:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764672AbYCELHm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 06:07:42 -0500
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:34189 "EHLO
	e28esmtp06.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752913AbYCELHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 06:07:40 -0500
Date: Wed, 5 Mar 2008 16:37:31 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Paul Menage <menage@google.com>
Cc: fedora-devel-list@redhat.com, opensuse-packaging@opensuse.org,
       lkml <linux-kernel@vger.kernel.org>,
       containers@lists.linux-foundation.org, Balbir Singh <balbir@in.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>
Subject: Re: [RFC] libcg: design and plans
Message-ID: <20080305110730.GB22217@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20080304152341.GB5659@linux.vnet.ibm.com> <6599ad830803042215n6aedb3eeub0c037e6a4e7bb34@mail.gmail.com> <20080305103343.GA22217@linux.vnet.ibm.com> <6599ad830803050241k590e4389ud95b9b3ef920f8b6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830803050241k590e4389ud95b9b3ef920f8b6@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2008 at 02:41:41AM -0800, Paul Menage wrote:
> On Wed, Mar 5, 2008 at 2:33 AM, Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:
> >
> >  So there are two different points, /mem and /cpu. /mem has A and C and
> >  /cpu has A, B and C. A and B of /cpu correspond to A of /mem and the C's
> >  are the same. With this is mind, if I say a task should move to B in
> >  /cpu, it should also move to A in /mem?
> >
> 
> Maybe clearer to say that /mem has two cgroups, AB and C. The
> abstraction provided by libcg would be of three groups, A, B and C.
> Asking libcg to move a process to abstract group B would result it
> moving to /mem/AB and /cpu/B
> 

OK. Hmm, I've not really thought about it. At first thought, it should
not be very difficult. Only thing I am not sure is the arbitrary
grouping of the groups (ok, a bit confusing). If that information is
maintained somewhere, it should be pretty straightforward. (Only thing
is that I am not sure how it will be done, and where the grouping
information should be stored. configuration looks like the logical
place, but I am not sure)

Thanks,
-- 
regards,
Dhaval
