Return-Path: <linux-kernel-owner+w=401wt.eu-S1757922AbZCDUSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757922AbZCDUSe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 15:18:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756156AbZCDUSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 15:18:11 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:33697 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752693AbZCDUSK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 15:18:10 -0500
Subject: Re: [PATCH 2/3] c/r: Add CR_COPY() macro (v3)
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Nathan Lynch <ntl@pobox.com>
Cc: containers@lists.osdl.org, Dan Smith <danms@us.ibm.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090304135314.618ad07e@thinkcentre.lan>
References: <1236095764-19325-1-git-send-email-danms@us.ibm.com>
	 <1236095764-19325-3-git-send-email-danms@us.ibm.com>
	 <1236097332.22399.8.camel@nimitz> <878wnmrtp9.fsf@caffeine.danplanet.com>
	 <1236128437.22399.31.camel@nimitz>
	 <20090304135314.618ad07e@thinkcentre.lan>
Content-Type: text/plain
Date: Wed, 04 Mar 2009 12:18:02 -0800
Message-Id: <1236197882.22399.40.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-04 at 13:53 -0600, Nathan Lynch wrote:
> On Tue, 03 Mar 2009 17:00:37 -0800
> Dave Hansen <dave@linux.vnet.ibm.com> wrote:
> 
> > On Tue, 2009-03-03 at 16:57 -0800, Dan Smith wrote:
> > > DH> Did you convince Nathan that this ends up being a good idea?
> > > 
> > > Technically he hasn't seen this version, but my hopes are not high
> > > that he will change his mind.  If the feedback is that they're not
> > > liked, I'll happily remove them.
> > 
> > I just figure if Nathan feels that strongly that we'll encounter more
> > people who feel even more so.  So, I was curious if he changed his mind
> > somehow.
> 
> No, not really, sorry.
> 
> I understand why it's nice for the developer to have this sort of
> helper, but I don't think it's nice for someone trying to review or
> debug the code.

That's funny.  I've only reviewed and debugged these things, but I don't
think I've actually written any code that would have used these macros!
As someone trying to debug and review, I love how this looks.

It gets the point across much more clearly about what is going on to me
as a reviewer and I appreciate that.  memcpy()s contain a lot of gunk
that my brain can't parse easily, but this is rather clean, and it
*HALVES* the number of lines of code I have to look at.  

> Surely discussing these macros has already consumed more developer time
> than they would ever save?  :)

That's exactly my point.  We're not trying to save development time here
at all.  My argument is that this reduces the maintenance and review
burden.  

-- Dave

