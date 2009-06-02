Return-Path: <linux-kernel-owner+w=401wt.eu-S1753757AbZFBUgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757AbZFBUgS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 16:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753237AbZFBUgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 16:36:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38410 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753113AbZFBUgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 16:36:05 -0400
Date: Tue, 2 Jun 2009 13:35:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: menage@google.com, lizf@cn.fujitsu.com, balbir@linux.vnet.ibm.com,
       kamezawa.hiroyu@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       bharata@linux.vnet.ibm.com, libcg-devel@lists.sourceforge.net
Subject: Re: +
 cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem. patch
 added to -mm tree
Message-Id: <20090602133534.d2e453f6.akpm@linux-foundation.org>
In-Reply-To: <20090602174042.GD16753@linux.vnet.ibm.com>
References: <200906020602.n5262wcu008560@imap1.linux-foundation.org>
	<20090602090944.GB16753@linux.vnet.ibm.com>
	<6599ad830906020908s7cb6afe6pd83ca35b82d148a4@mail.gmail.com>
	<20090602174042.GD16753@linux.vnet.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Jun 2009 23:10:42 +0530
Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:

> On Tue, Jun 02, 2009 at 09:08:04AM -0700, Paul Menage wrote:
> > On Tue, Jun 2, 2009 at 2:09 AM, Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:
> > >
> > > I am not sure if this is a good idea. For libcgroup, we would then be
> > > adding a special case for just cpuset. I would rather that we allow it
> > > either for all the subsystems or none of them.
> > >
> > 
> > libcgroup shouldn't be using the noprefix option. Its only intentded
> > use is to allow the legacy "cpuset" filesystem type to be mounted and
> > to see the same fileset as it had before the cgroups transition.
> > 
> 
> It does not. But if some user is using that option, we need to be in a
> position to handle it.
> 
> I am quite happy not supporting the noprefix option in the library if it
> is fine.
> 

fyi, the above discussion transitions akpm into the "confused" state. 
I'll keep the patch on hold until akpm transitions back out of that
state.

