Return-Path: <linux-kernel-owner+w=401wt.eu-S934848AbXFFSG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934848AbXFFSG6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 14:06:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756283AbXFFSGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 14:06:49 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:41526 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755486AbXFFSGr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 14:06:47 -0400
Date: Wed, 6 Jun 2007 11:06:31 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Eric Paris <eparis@redhat.com>
Cc: Alan Cox <alan@redhat.com>, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov, drepper@redhat.com,
       roland@redhat.com, arjan@infradead.org, mingo@elte.hu,
       viro@zeniv.linux.org.uk, chrisw@redhat.com, sds@tycho.nsa.gov,
       sgrubb@redhat.com
Subject: Re: [PATCH] Protection for exploiting null dereference using mmap
Message-ID: <20070606180631.GP3723@sequoia.sous-sol.org>
References: <1180561713.3633.27.camel@dhcp231-215.rdu.redhat.com> <20070603205653.GE25869@devserv.devel.redhat.com> <1180964306.14220.34.camel@moss-spartans.epoch.ncsc.mil> <1181075666.3978.31.camel@localhost.localdomain> <Line.LNX.4.64.0706051658170.23379@d.namei> <20070605211616.GE23291@devserv.devel.redhat.com> <1181111433.3978.48.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181111433.3978.48.camel@localhost.localdomain>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Eric Paris (eparis@redhat.com) wrote:
> On Tue, 2007-06-05 at 17:16 -0400, Alan Cox wrote:
> > On Tue, Jun 05, 2007 at 05:00:51PM -0400, James Morris wrote:
> > > This should be an unsigned long.
> > > 
> > > I wonder if the default should be for this value to be zero (i.e. preserve 
> > > existing behavior).  It could break binaries, albeit potentially insecure 
> > 
> > Agreed - DOSemu type apps and lrmi need to map at zero for vm86
> 
> And so it shall be!
> 
> Signed-off-by: Eric Paris <eparis@redhat.com>

With James' fix and real changelog ;-)

Acked-by: Chris Wright <chrisw@sous-sol.org>
