Return-Path: <linux-kernel-owner+w=401wt.eu-S1757741AbZFBRlG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757741AbZFBRlG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 13:41:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754861AbZFBRkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 13:40:55 -0400
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:60892 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864AbZFBRky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 13:40:54 -0400
Date: Tue, 2 Jun 2009 23:10:42 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Paul Menage <menage@google.com>
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org, lizf@cn.fujitsu.com,
       balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com,
       lkml <linux-kernel@vger.kernel.org>,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       libcg-devel <libcg-devel@lists.sourceforge.net>
Subject: Re: +
	cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem.
	patch added to -mm tree
Message-ID: <20090602174042.GD16753@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <200906020602.n5262wcu008560@imap1.linux-foundation.org> <20090602090944.GB16753@linux.vnet.ibm.com> <6599ad830906020908s7cb6afe6pd83ca35b82d148a4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830906020908s7cb6afe6pd83ca35b82d148a4@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 02, 2009 at 09:08:04AM -0700, Paul Menage wrote:
> On Tue, Jun 2, 2009 at 2:09 AM, Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:
> >
> > I am not sure if this is a good idea. For libcgroup, we would then be
> > adding a special case for just cpuset. I would rather that we allow it
> > either for all the subsystems or none of them.
> >
> 
> libcgroup shouldn't be using the noprefix option. Its only intentded
> use is to allow the legacy "cpuset" filesystem type to be mounted and
> to see the same fileset as it had before the cgroups transition.
> 

It does not. But if some user is using that option, we need to be in a
position to handle it.

I am quite happy not supporting the noprefix option in the library if it
is fine.

Thanks,
-- 
regards,
Dhaval
