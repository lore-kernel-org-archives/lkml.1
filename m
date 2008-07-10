Return-Path: <linux-kernel-owner+w=401wt.eu-S1759723AbYGJRqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759723AbYGJRqV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 13:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753352AbYGJRqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 13:46:12 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:35479 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088AbYGJRqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 13:46:11 -0400
Date: Thu, 10 Jul 2008 23:14:36 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Paul Menage <menage@google.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Peter Zijlstra <pzijlstr@redhat.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Libcg Devel Mailing List <libcg-devel@lists.sourceforge.net>,
       Morton Andrew Morton <akpm@linux-foundation.org>,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [Libcg-devel] [RFC] How to handle the rules engine for cgroups
Message-ID: <20080710174436.GE4235@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20080701191126.GA17376@redhat.com> <6599ad830807100207q26cf2416qb8d38d1d715b5ba0@mail.gmail.com> <20080710143307.GD3782@redhat.com> <6599ad830807100946j6db8d0d6se18f1b428c69ad5c@mail.gmail.com> <20080710171838.GA4235@linux.vnet.ibm.com> <6599ad830807101030i2f3a15a3l3409a36c11773f25@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830807101030i2f3a15a3l3409a36c11773f25@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2008 at 10:30:15AM -0700, Paul Menage wrote:
> On Thu, Jul 10, 2008 at 10:18 AM, Dhaval Giani
> <dhaval@linux.vnet.ibm.com> wrote:
> >
> > I am sorry, I seem to missing something, but who moves the forked
> > children (which got forked during the time between the parent getting
> > classified into the right group and the fork itself) into the correct
> > group?
> 
> The classifier daemon would have to do that - my point was that it
> would be very clear exactly which processes needed this attention,
> since they'd end up in the root cgroup too.
> 

It still would not solve the problem of the correct group getting
charged. Say for something like cpu, it would get fare more cpu time as
opposed to what it should get. Its in the correct direction, but I am
not sure if it is the solution. I was thinking of having a sandbox
cgroup at each level, but then I am not very sure of this "correct
cgroup getting charged" problem.

-- 
regards,
Dhaval
