Return-Path: <linux-kernel-owner+w=401wt.eu-S1756742AbZDDVZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742AbZDDVZb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 17:25:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751611AbZDDVZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 17:25:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36422 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043AbZDDVZU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 17:25:20 -0400
Date: Sat, 4 Apr 2009 23:24:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dave Jones <davej@redhat.com>,
       Tarkan Erimer <tarkan.erimer@turknet.net.tr>,
       linux-kernel@vger.kernel.org
Subject: Re: Linux-2.6.29-git6 Compile Error
Message-ID: <20090404212450.GA14729@elte.hu>
References: <49D0D3DF.1050008@turknet.net.tr> <20090330143438.GA6736@elte.hu> <20090330164702.GA6372@redhat.com> <20090403174701.GF6295@elte.hu> <20090403175355.GB26888@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090403175355.GB26888@redhat.com>
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


* Dave Jones <davej@redhat.com> wrote:

> On Fri, Apr 03, 2009 at 07:47:01PM +0200, Ingo Molnar wrote:
>  > 
>  > * Dave Jones <davej@redhat.com> wrote:
>  > 
>  > > On Mon, Mar 30, 2009 at 04:34:38PM +0200, Ingo Molnar wrote:
>  > >  > 
>  > >  > (Cc: added)
>  > > 
>  > > See 199785eac892a1fa1b71cc22bec58e8b156d9311
>  > > Steven picked up in this build failure _months_ ago in -next,
>  > > which caused me to regenerate the cpufreq tree so that the build failure
>  > > wouldn't get introduced to mainline.
>  > > 
>  > > Then the x86-merge comes along, and steamrollers over it.
>  > 
>  > hmmm ... there certainly was no build failure observable here. 
>  > Which commit caused the problem? 199785eac8 went in via your 
>  > tree, not the x86 tree.
> 
> The commits that moved the include file around reverted the 
> changes from 199785eac8.

ah. That was indeed my bad - sorry about that. Should we have 
applied that fix to the x86 tree or did it only make sense after
the merge?

	Ingo
