Return-Path: <linux-kernel-owner+w=401wt.eu-S1754382AbZFSOGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382AbZFSOGZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 10:06:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751559AbZFSOGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 10:06:17 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41631 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751340AbZFSOGR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 10:06:17 -0400
Date: Fri, 19 Jun 2009 10:05:26 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com,
       fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, jbaron@redhat.com,
       agk@redhat.com, snitzer@redhat.com, akpm@linux-foundation.org,
       peterz@infradead.org
Subject: Re: [PATCH 18/19] io-controller: Debug hierarchical IO scheduling
Message-ID: <20090619140526.GB3726@redhat.com>
References: <1244513342-11758-1-git-send-email-vgoyal@redhat.com> <1244513342-11758-19-git-send-email-vgoyal@redhat.com> <4A3AEC96.7050500@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A3AEC96.7050500@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 19, 2009 at 09:40:38AM +0800, Gui Jianfeng wrote:

[..]
> > + * An entity has been freshly added to active tree. Either it came from
> > + * idle tree or it was not on any of the trees. Do the accounting.
> > + */
> > +static inline void bfq_account_for_entity_addition(struct io_entity *entity)
> > +{
> > +	struct io_group *iog = io_entity_to_iog(entity);
> > +
> > +	if (iog) {
> > +		struct elv_fq_data *efqd;
> > +		char path[128];
> > +
> > +		/*
> > +		 * Keep track of how many times a group has been removed
> > +		 * from active tree because it did not have any active
> > +		 * backlogged ioq under it
> > +		 */
> 
> Hi Vivek,
> 
> Should the comment here be "added to" rather than "removed from"?

Yes, it is copy paste error. Fixed for next posting.

Thanks
Vivek
