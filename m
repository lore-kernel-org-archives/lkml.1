Return-Path: <linux-kernel-owner+w=401wt.eu-S1755450AbYANUCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450AbYANUCd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 15:02:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752968AbYANUCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 15:02:22 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:33729 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbYANUCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 15:02:21 -0500
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett Packard
To: Valdis.Kletnieks@vt.edu
Subject: Re: 2.6.24-rc6-mm1 - oddness with IPv4/v6 mapped sockets hanging...
Date: Mon, 14 Jan 2008 15:02:12 -0500
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
References: <30887.1200209733@turing-police.cc.vt.edu> <200801141407.46345.paul.moore@hp.com> <3727.1200339422@turing-police.cc.vt.edu>
In-Reply-To: <3727.1200339422@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801141502.12954.paul.moore@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 January 2008 2:37:02 pm Valdis.Kletnieks@vt.edu wrote:
> On Mon, 14 Jan 2008 14:07:46 EST, Paul Moore said:
> > There have been quite a few changes in lblnet-2.6_testing since
> > 2.6.24-rc6-mm1 so I would recommend taking the whole tree.  I'm also not
> > quite sure if
>
> Weird.  I did a 'git clone
> git://git.infradead.org/users/pcmoore/lblnet-2.6_testing' into a new
> directory this morning, and doing a 'git log' against that only showed the
> one added commit:
>
> commit 5d95575903fd3865b884952bd93c339d48725c33
> Author: Paul Moore <paul.moore@hp.com>
> Date:   Wed Jan 9 15:30:23 2008 -0500
>
>     SELinux: Add warning messages on network denial due to error
>
>     Currently network traffic can be sliently dropped due to non-avc errors
> which can lead to much confusion when trying to debug the problem.  This
> patch adds warning messages so that when these events occur there is a user
> visible notification.
>
>     Signed-off-by: Paul Moore <paul.moore@hp.com>
>
> commit 9259ca5fd8b9fbdd2c3edade593dead905d8391e
> Author: Paul Moore <paul.moore@hp.com>
> Date:   Wed Jan 9 15:30:23 2008 -0500
>
>     SELinux: Add network ingress and egress control permission checks
> (already in 24-rc6-mm1).
>
> Somebody please tell me it's my git-idiocy..

It might be something on my end with managing the lblnet-2.6_testing git tree; 
I'm still pretty clueless when it comes to git.

I've got a git tree on my dev machine which is backed against Linus' tree and 
managed via stacked-git.  I update the patches in this tree, refresh them 
against new bits from Linus, etc and when something significant changes I 
update the git tree on infradead.org and post a new patchset to the related 
lists.  The process of updating the git tree on infradead.org usually 
involves deleting the entire tree located there, re-creating it, and then 
doing a git-push from my dev machine.  I have no idea if this is "correct" or 
not, but I've often wondered if this is a the "right" way to do it ...

-- 
paul moore
linux security @ hp
