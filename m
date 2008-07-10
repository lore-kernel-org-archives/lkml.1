Return-Path: <linux-kernel-owner+w=401wt.eu-S1758591AbYGJRTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758591AbYGJRTa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 13:19:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756989AbYGJRTV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 13:19:21 -0400
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:53501 "EHLO
	e28esmtp01.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759505AbYGJRTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 13:19:20 -0400
Date: Thu, 10 Jul 2008 22:48:38 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Paul Menage <menage@google.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Peter Zijlstra <pzijlstr@redhat.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Libcg Devel Mailing List <libcg-devel@lists.sourceforge.net>,
       Morton Andrew Morton <akpm@linux-foundation.org>,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [Libcg-devel] [RFC] How to handle the rules engine for cgroups
Message-ID: <20080710171838.GA4235@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20080701191126.GA17376@redhat.com> <6599ad830807100207q26cf2416qb8d38d1d715b5ba0@mail.gmail.com> <20080710143307.GD3782@redhat.com> <6599ad830807100946j6db8d0d6se18f1b428c69ad5c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830807100946j6db8d0d6se18f1b428c69ad5c@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2008 at 09:46:46AM -0700, Paul Menage wrote:
> On Thu, Jul 10, 2008 at 7:33 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > We also need to do something to track all the forked childs after
> > the setuid, setgid or exec till original parent event got classified
> > and children need to meet the same treatment.
> 
> You'd get that automatically, since children of the task moved to the
> root cgroup (indicating "needs attention") would also end up in that
> cgroup since cgroup are inherited across fork.
> 

I am sorry, I seem to missing something, but who moves the forked
children (which got forked during the time between the parent getting
classified into the right group and the fork itself) into the correct
group?

-- 
regards,
Dhaval
