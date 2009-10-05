Return-Path: <linux-kernel-owner+w=401wt.eu-S1755432AbZJEXsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432AbZJEXsY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 19:48:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755201AbZJEXsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 19:48:23 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59873 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531AbZJEXsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 19:48:23 -0400
Date: Mon, 5 Oct 2009 19:47:41 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH trivial] docs: fix core_pipe_limit info
Message-ID: <20091005234741.GA7538@localhost.localdomain>
References: <4AC95891.3000707@oracle.com> <alpine.LSU.2.00.0910060003310.10941@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.0910060003310.10941@wotan.suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -4.5 (----)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 06, 2009 at 12:03:40AM +0200, Jiri Kosina wrote:
> On Sun, 4 Oct 2009, Randy Dunlap wrote:
> 
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> > Fix typos in core_pipe_limit info.
> > 
> > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> > Cc: Neil Horman <nhorman@tuxdriver.com>
> > ---
> >  Documentation/sysctl/kernel.txt |    6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > --- linux-next-20090930.orig/Documentation/sysctl/kernel.txt
> > +++ linux-next-20090930/Documentation/sysctl/kernel.txt
> > @@ -139,9 +139,9 @@ core_pattern is used to specify a core d
> >  core_pipe_limit:
> >  
> >  This sysctl is only applicable when core_pattern is configured to pipe core
> > -files to user space helper a (when the first character of core_pattern is a '|',
> > +files to a user space helper (when the first character of core_pattern is a '|',
> >  see above).  When collecting cores via a pipe to an application, it is
> > -occasionally usefull for the collecting application to gather data about the
> > +occasionally useful for the collecting application to gather data about the
> >  crashing process from its /proc/pid directory.  In order to do this safely, the
> >  kernel must wait for the collecting process to exit, so as not to remove the
> >  crashing processes proc files prematurely.  This in turn creates the possibility
> > @@ -152,7 +152,7 @@ applications in parallel.  If this value
> >  processes above that value are noted via the kernel log and their cores are
> >  skipped.  0 is a special value, indicating that unlimited processes may be
> >  captured in parallel, but that no waiting will take place (i.e. the collecting
> > -process is not guaranteed access to /proc/<crahing pid>/).  This value defaults
> > +process is not guaranteed access to /proc/<crashing pid>/).  This value defaults
> >  to 0.
> 
> Applied to trivial queue, thanks Randy.
> 
Thank you Randy, Jiri.
Neil

> -- 
> Jiri Kosina
> SUSE Labs, Novell Inc.
> 
