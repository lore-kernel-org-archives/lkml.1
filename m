Return-Path: <linux-kernel-owner+w=401wt.eu-S1761660AbYFKPgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761660AbYFKPgv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 11:36:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753905AbYFKPgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 11:36:43 -0400
Received: from p548E1A10.dip0.t-ipconnect.de ([84.142.26.16]:61652 "EHLO
	be1.lrz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753076AbYFKPgn (ORCPT <rfc822; linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 11:36:43 -0400
X-Greylist: delayed 555 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Jun 2008 11:36:42 EDT
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: sched_yield() on 2.6.25
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Jakub Jozwicki <jozwicki@aster.pl>, linux-kernel@vger.kernel.org,
       Robert Hancock <hancockr@shaw.ca>
Reply-To: 7eggert@gmx.de
Date: Wed, 11 Jun 2008 17:28:06 +0200
References: <aCBfw-3Cv-23@gated-at.bofh.it> <aCBfw-3Cv-21@gated-at.bofh.it> <aCJd6-3IF-11@gated-at.bofh.it> <aCRaM-8cM-33@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <20080611152807.0682218F62@be1.lrz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Mon, 2008-06-09 at 08:37 +0200, Jakub Jozwicki wrote:

>> From the man sched_yield:
>> 
>> A  process  can  relinquish  the  processor  voluntarily without blocking by
>> calling sched_yield().  The process will then be moved to the  end  of  the
>> queue  for  its static priority and a new process gets to run.
>> 
>> and also IEEE/Open Group:
>> http://www.opengroup.org/onlinepubs/000095399/functions/sched_yield.html
> 
> Yeah, except that is for Real-Time scheduling classes, SCHED_OTHER
> doesn't have static priority queues.
> 
> SCHED_OTHER doesn't have a specified implementation - so relying on it
> to do anything specific is well outside the scope of definition.

OTOH, it's sane not to schedule exactly the thread which just tried
to say "I can't do any sane work, please run another thread.

