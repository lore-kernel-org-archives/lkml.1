Return-Path: <linux-kernel-owner+w=401wt.eu-S1753915AbZIHHKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915AbZIHHKi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 03:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753876AbZIHHKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 03:10:37 -0400
Received: from mail-pz0-f184.google.com ([209.85.222.184]:51179 "EHLO
	mail-pz0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753862AbZIHHKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 03:10:35 -0400
Subject: Re: question on sched-rt group allocation cap: sched_rt_runtime_us
Mime-Version: 1.0 (Apple Message framework v1075.2)
Content-Type: text/plain; charset=us-ascii; format=flowed; delsp=yes
From: Anirban Sinha <ani@anirban.org>
In-Reply-To: <DDFD17CC94A9BD49A82147DDF7D545C54DC489@exchange.ZeugmaSystems.local>
Date: Tue, 8 Sep 2009 00:10:32 -0700
Cc: Anirban Sinha <ASinha@zeugmasystems.com>, Anirban Sinha <ani@anirban.org>
Content-Transfer-Encoding: 7bit
Message-Id: <7D542E15-CEA4-43CD-AB4E-48ED103EE7B9@anirban.org>
References: <dgRNo-3uc-5@gated-at.bofh.it> <dhb9j-1hp-5@gated-at.bofh.it> <dhcf5-263-13@gated-at.bofh.it> <36bbf267-be27-4c9e-b782-91ed32a1dfe9@g1g2000pra.googlegroups.com> <1252218779.6126.17.camel@marge.simson.net> <DDFD17CC94A9BD49A82147DDF7D545C54DC483@exchange.ZeugmaSystems.local> <1252306486.7423.72.camel@marge.simson.net> <DDFD17CC94A9BD49A82147DDF7D545C54DC489@exchange.ZeugmaSystems.local>
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dario Faggioli <raistlin@linux.it>, Mike Galbraith <efault@gmx.de>
X-Mailer: Apple Mail (2.1075.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2009-09-07, at 9:44 AM, Anirban Sinha wrote:

>
>
>
> -----Original Message-----
> From: Mike Galbraith [mailto:efault@gmx.de]
> Sent: Sun 9/6/2009 11:54 PM
> To: Anirban Sinha
> Cc: Lucas De Marchi; linux-kernel@vger.kernel.org; Peter Zijlstra;  
> Ingo Molnar
> Subject: RE: question on sched-rt group allocation cap:  
> sched_rt_runtime_us
>
> On Sun, 2009-09-06 at 17:18 -0700, Anirban Sinha wrote:
> >
> >
> > > Dunno.  Fly or die little patchlet (toss).
> >
> > > sched: allow the user to disable RT bandwidth aggregation.
> >
> > Hmm. Interesting. With this change, my results are as follows:
> >
> > rt_runtime/rt_period   % of reg iterations
> >
> > 0.2                    100%
> > 0.25                   100%
> > 0.3                    100%
> > 0.4                    100%
> > 0.5                    82%
> > 0.6                    66%
> > 0.7                    54%
> > 0.8                    46%
> > 0.9                    38.5%
> > 0.95                   32%
> >
> >
> > This results are on a quad core blade. Does it still makes sense
> > though?
> > Can anyone else run the same tests on a quadcore over the latest
> > kernel? I will patch our 2.6.26 kernel with upstream fixes and rerun
> > these tests on tuesday.
>
> I tested tip (v2.6.31-rc9-1357-ge6a3cd0) with a little perturbation
> measurement proglet on an isolated Q6600 core.


Thanks Mike. Is this on a single core machine (or one core carved out  
of N)?  We may have some newer patches missing from the 2.6.26 kernel  
that fixes some accounting bugs. I will do a review and rerun the test  
after applying the upstream patches.

Ani

