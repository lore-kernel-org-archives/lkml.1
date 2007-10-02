Return-Path: <linux-kernel-owner+w=401wt.eu-S1757483AbXJCKKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483AbXJCKKu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 06:10:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753177AbXJCKKn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 06:10:43 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:28320 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752136AbXJCKKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 06:10:43 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=E75C8B6/EMxqybnawGBeT6yHgHqk5idAaXic4SLv49tUgYL2lCcZ3FZGU6EL3gmJ9s148P/cl700755ofcP73obQ+fso8Z4b/M2oIstPHvvgwtnxzvguoN+l+Wl+G/Zk3vrJ1qDK89PE7Cfu7SAT/nnsyJr5UKAuLh8iwXlfjSM=  ;
X-YMail-OSG: 9LsKYHcVM1mmdCnKBtcTXyeSbLUjpCFP0fBkBxTpZ_LY.Y5HTJai4eT6916n_6AJpkzmAlJgNg--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Paul Jackson <pj@sgi.com>
Subject: Re: [patch] sched: fix sched-domains partitioning by cpusets
Date: Wed, 3 Oct 2007 03:29:56 +1000
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org, menage@google.com,
       linux-kernel@vger.kernel.org, dino@in.ibm.com, cpw@sgi.com
References: <20070930104403.24828.48263.sendpatchset@jackhammer.engr.sgi.com> <20071003093517.GA22558@elte.hu> <20071003023924.c4c5b2ef.pj@sgi.com>
In-Reply-To: <20071003023924.c4c5b2ef.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710030329.57274.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 October 2007 19:39, Paul Jackson wrote:
> > in any case i'd like to see the externally visible API get in foremost -
> > and there now seems to be agreement about that. (yay!) Any internal
> > shaping of APIs can be done flexibly between cpusets and the scheduler.
>
> Yup - though Nick and I will have to agree to -some- internal interface
> between the cpuset and sched code, at least for the moment.
>
> At least, if we thrash about on this, we won't be changing the externally
> visible API around.  We'll just continue driving Andrew nuts, not our
> users - that's an improvement.

OK look, I don't want to hold up progress. I do like to ask these questions
and be difficult if I think there might be a better way and/or to make sure
you've thought about all the angles. I'm not volunteering to maintain
cpusets and I'm not as close to the customers who care as you.

Obviously what your patches do here is a lot closer to "the right thing"
than cpus_exclusive. And the worst problem they'll cause is to add
cruft to cpusets.c.

So I'll keep persuing the other subthread for the same reasons, but aside
from implementation nits, I don't know if it is worth holding up a merge.
