Return-Path: <linux-kernel-owner+w=401wt.eu-S1755867AbZFCFVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867AbZFCFVS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 01:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbZFCFVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 01:21:10 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:51847 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbZFCFVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 01:21:09 -0400
Date: Wed, 3 Jun 2009 10:50:53 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: menage@google.com, lizf@cn.fujitsu.com, balbir@linux.vnet.ibm.com,
       kamezawa.hiroyu@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       bharata@linux.vnet.ibm.com, libcg-devel@lists.sourceforge.net
Subject: Re: +
	cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem.
	patch added to -mm tree
Message-ID: <20090603052053.GA3910@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <200906020602.n5262wcu008560@imap1.linux-foundation.org> <20090602090944.GB16753@linux.vnet.ibm.com> <6599ad830906020908s7cb6afe6pd83ca35b82d148a4@mail.gmail.com> <20090602174042.GD16753@linux.vnet.ibm.com> <20090602133534.d2e453f6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090602133534.d2e453f6.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 02, 2009 at 01:35:34PM -0700, Andrew Morton wrote:
> On Tue, 2 Jun 2009 23:10:42 +0530
> Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:
> 
> > On Tue, Jun 02, 2009 at 09:08:04AM -0700, Paul Menage wrote:
> > > On Tue, Jun 2, 2009 at 2:09 AM, Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:
> > > >
> > > > I am not sure if this is a good idea. For libcgroup, we would then be
> > > > adding a special case for just cpuset. I would rather that we allow it
> > > > either for all the subsystems or none of them.
> > > >
> > > 
> > > libcgroup shouldn't be using the noprefix option. Its only intentded
> > > use is to allow the legacy "cpuset" filesystem type to be mounted and
> > > to see the same fileset as it had before the cgroups transition.
> > > 
> > 
> > It does not. But if some user is using that option, we need to be in a
> > position to handle it.
> > 
> > I am quite happy not supporting the noprefix option in the library if it
> > is fine.
> > 
> 
> fyi, the above discussion transitions akpm into the "confused" state. 
> I'll keep the patch on hold until akpm transitions back out of that
> state.

I can help with that :).

We will not support noprefix in libcgroup and this patch should go in
because it fixes an obvious bug.

Thanks,
-- 
regards,
Dhaval
