Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604Ab0CITxJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 14:53:09 -0500
Received: from quartz.orcorp.ca ([139.142.54.143]:43518 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752693Ab0CITxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 14:53:06 -0500
Date: Tue, 9 Mar 2010 12:53:03 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: "David P. Quigley" <dpquigl@tycho.nsa.gov>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>,
       Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] sysfs: Fixup broken chown tracking
Message-ID: <20100309195303.GH29129@obsidianresearch.com>
References: <20100309191127.GA30462@obsidianresearch.com> <1268163372.29493.1965.camel@moss-terrapins.epoch.ncsc.mil> <20100309194201.GA869@suse.de> <1268163988.29493.1970.camel@moss-terrapins.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268163988.29493.1970.camel@moss-terrapins.epoch.ncsc.mil>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 09, 2010 at 02:46:28PM -0500, David P. Quigley wrote:
> On Tue, 2010-03-09 at 11:42 -0800, Greg KH wrote:
> > On Tue, Mar 09, 2010 at 02:36:12PM -0500, David P. Quigley wrote:
> > > It looks like your patch is already in the tree as commit
> > > 7c0ff870d1ed287504a61ed865f3d728c757436b. We saw this problem before and
> > > Eric fixed it up. I thought it was very odd that you posted this 5
> > > minutes ago and it was already upstream.
> > 
> > Yeah, this has already been resolved, did that patch not solve the issue
> > for you?
> 
> I don't see how it couldn't have. The patch he submitted which he says
> fixes the problem is the exact same patch that Eric submitted back in
> Feb. Its possible that he is using a version of 2.6.33-rc8 that is based
> off of a commit before the patch was merged since 2.6.33-rc8 was tagged
> on Feb 12th and your commit date in the repo is Feb 16th.

Yes, that is correct, I was only looking up to 2.6.33-rc8, I didn't
think to check Linus's head branch, my mistake. It looks to me like
the changeset you pointed to was put in Linus's tree after that tag,
so it is fixed, just not in any tagged kernel.

Thanks for looking at this,
Jason
