Return-Path: <linux-kernel-owner+w=401wt.eu-S1754162AbZGRBBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162AbZGRBBs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 21:01:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753014AbZGRBBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 21:01:47 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:16356 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbZGRBBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 21:01:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=o9s1e2QlqCb0sZnMrgXwZvQCQLXK6dZA6eQIWFP4pWTQ/hkGwc7RQdFOBPhKwao/lB
         lI4T4jU4yvR1w42Aj85ATheSDBObGwu+gXy0LRlD/yVJ/82XNHAVeAnc5DHS4KFyr8iN
         YdM90ZDRYL/qljM4Pmuq+xKQ/CI+ivo5PyR9g=
Date: Sat, 18 Jul 2009 03:00:21 +0200
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tj Hariharan <tj.physicist@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: kernel stuck at trying to change CPU resolution.
Message-ID: <20090718010020.GA20213@Pilar.aei.mpg.de>
References: <20090626111652.GA7244@TjsLaptop> <20090717153742.d9144d91.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090717153742.d9144d91.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 17.Jul'09 at 15:37:42 -0700, Andrew Morton wrote:
> On Fri, 26 Jun 2009 07:16:53 -0400
> Tj Hariharan <tj.physicist@gmail.com> wrote:
> 
> > 
> > Hi, I have a Pentium-M 1.86GHZ processor Laptop. Standard DELL Latitude
> > D610. I ran the 2.6.31-rc1 kernel (updated tree as of 10 minutes ago).
> > The kernel gets stuck at the message saying "Switching to High
> > resolution mode on CPU0" after about 10 minutes it goes to the next
> > step, but then continues to get stuck. There is no log, as presumable
> > this is happening before the kernel fully initialises the harddrive and
> > passes control to user mode. I am running a non modular kernel with no
> > major changes made to my configuration since 2.6.27. I have never had
> > any issues thus far. Since I am using a laptop I am unable to access the
> > sysrq key (which in my case is not prnt screen, but Fn+PrintScreen, and
> > Fn key is not read by kernel at all, even after full boot and under
> > normal conditions). Thank you for your time. I have also attached my
> > config file. 
> > 
> 
> Thanks for the report.
> 
> Is this regression still present in 2.6.31-rc3 or later?
> 
> If so, do you know if the bug was present in 2.6.30/29/28?

The above description made me remember about 
http://lkml.org/lkml/2007/4/30/464
and
http://lkml.org/lkml/2007/12/14/148

Perhaps it is just coincidence and the bugs are not related, but
I felt the need to point them out just in case.
