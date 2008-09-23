Return-Path: <linux-kernel-owner+w=401wt.eu-S1753363AbYIWPfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363AbYIWPfv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 11:35:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751647AbYIWPfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 11:35:44 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47204 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465AbYIWPfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 11:35:43 -0400
Date: Tue, 23 Sep 2008 12:35:59 -0300
From: Glauber Costa <glommer@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Glauber Costa <gcosta@redhat.com>, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [GIT-PULL] Split time.c series: part 1
Message-ID: <20080923153559.GA3583@poweredge.glommer>
References: <200809221857.m8MIvXUB019029@ns3.rdu.redhat.com> <20080923111935.GK29021@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080923111935.GK29021@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2008 at 01:19:35PM +0200, Ingo Molnar wrote:
> 
> * Glauber Costa <gcosta@redhat.com> wrote:
> 
> > Ingo, please pull the latest master branch git tree from:
> > 
> >    git://git.kernel.org/pub/scm/linux/kernel/git/glommer/linux-2.6-x86-integration.git ingo-time
> > 
> > into your tree
> 
> hm, there's no ingo-time branch there. Forgot to push out? But the 
> 'master' branch seems to match up with your diffstat, so i pulled that 
> one instead.
yeah, sure. My mistake.

> 
> > It contains the part of time.c integration that is considered mostly 
> > safe, and does not touch (but one reorganization patch) the interrupt 
> > code. It should go smootly, but it's (should be) bisection friendly in 
> > case it doesn't.
> 
> i've restructured the dependencies a bit: i've put your changes into 
> tip/x86/time and based them on tip/x86/core (not tip/master). It 
> integrates cleanly into tip/master and i've started testing them.
cool. Let me know how it goes.

> 
> Thanks,
> 
> 	Ingo
