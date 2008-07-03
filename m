Return-Path: <linux-kernel-owner+w=401wt.eu-S1757303AbYGCNPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303AbYGCNPi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 09:15:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753092AbYGCNPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 09:15:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45756 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723AbYGCNP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 09:15:29 -0400
Date: Thu, 3 Jul 2008 15:14:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Bernhard Walle <bwalle@suse.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@redhat.com>, x86@kernel.org,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Find offset for crashkernel reservation
	automatically
Message-ID: <20080703131456.GA12102@elte.hu>
References: <1214510048-21215-1-git-send-email-bwalle@suse.de> <20080627133256.GB5801@redhat.com> <20080627134212.GC5801@redhat.com> <20080627160656.06f71661@halley.suse.de> <20080627141910.GD5801@redhat.com> <20080627162223.2df5a8b9@halley.suse.de> <m1zlp6vjub.fsf@frodo.ebiederm.org> <20080627202932.16634031@kopernikus.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080627202932.16634031@kopernikus.site>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Bernhard Walle <bwalle@suse.de> wrote:

> > > But in general policy should go in userspace (if possible), so I 
> > > agree with you that kexec-tools can handle that.
> > 
> > At a quick skim the patch looks good.  I thought I had initially 
> > implemented the code to work this way but apparently in all of the 
> > churn that aspect of it got lost.
> > 
> > Let's start with trying to allocate the memory as low as possible 
> > for a crash kernel (I think you are already doing that).
> 
> Yes, in 95 % of the cases the crashkernel still gets reserved at 16M.

ok - i've applied it to tip/x86/crashdump - thanks Bernhard.

	Ingo
