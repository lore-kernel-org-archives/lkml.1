Return-Path: <linux-kernel-owner+w=401wt.eu-S1757915AbZIRSks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757915AbZIRSks (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 14:40:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757516AbZIRSkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 14:40:45 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:55250 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757508AbZIRSkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 14:40:45 -0400
Date: Fri, 18 Sep 2009 11:39:26 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: "Peter W. Morreale" <pmorreale@novell.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Mark Fasheh <mfasheh@suse.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [GIT PULL] ocfs2 changes for 2.6.32
Message-ID: <20090918183926.GB8551@mail.oracle.com>
Mail-Followup-To: "Peter W. Morreale" <pmorreale@novell.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Mark Fasheh <mfasheh@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	ocfs2-devel@oss.oracle.com
References: <20090915005417.GD4507@mail.oracle.com>
 <alpine.LFD.2.01.0909141828070.4950@localhost.localdomain>
 <20090915040601.GE4507@mail.oracle.com>
 <alpine.LFD.2.01.0909150923180.4950@localhost.localdomain>
 <20090915214530.GA11060@mail.oracle.com>
 <alpine.LFD.2.01.0909152116180.4950@localhost.localdomain>
 <20090916044047.GA30453@mail.oracle.com>
 <alpine.LFD.2.01.0909170856050.4950@localhost.localdomain>
 <20090918014333.GD15620@mail.oracle.com>
 <1253294613.31359.136.camel@hermosa>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253294613.31359.136.camel@hermosa>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4AB3D404.00A6:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 18, 2009 at 11:23:33AM -0600, Peter W. Morreale wrote:
> On Thu, 2009-09-17 at 18:43 -0700, Joel Becker wrote:
> > On Thu, Sep 17, 2009 at 09:29:14AM -0700, Linus Torvalds wrote:
> > > Why would anybody want to hide it at all? Why even the libc hiding?
> > > 
> > > Nobody is going to use this except for special apps. Let them see what 
> > > they can do, in all its glory. 
> > 
> > 	I expect everyone will use this through cp(1), so that cp(1) can
> > try to get server-side copy on the network filesystms.
> > 	Speaking of "all its glory", what we have now is:
> > 
> > int sys_copyfileat(int oldfd, const char *oldname, int newfd,
> >                    const char *newname, int flags, int atflags)
> 
> 
> Would it be worthwhile to consider adding an offset and length?  
> 
> Then we get dd as well. (potentially) 

	I'm with Linus that a range attribute really makes this
complicated.  I also think it doesn't work well with a call that is
supposed to create newname.

Joel

-- 

	Pitchers and catchers report.

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
