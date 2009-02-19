Return-Path: <linux-kernel-owner+w=401wt.eu-S1757257AbZBSMCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757257AbZBSMCQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 07:02:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752238AbZBSMCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 07:02:00 -0500
Received: from cantor.suse.de ([195.135.220.2]:47126 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752692AbZBSMCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 07:02:00 -0500
Date: Thu, 19 Feb 2009 13:01:58 +0100
From: Nick Piggin <npiggin@suse.de>
To: Carsten Aulbert <carsten.aulbert@aei.mpg.de>,
       "xfs@oss.sgi.com" <xfs@oss.sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: xfs problems (possibly after upgrading from linux kernel 2.6.27.10 to .14)
Message-ID: <20090219120158.GA1747@wotan.suse.de>
References: <499ACE6C.4060304@aei.mpg.de> <20090218091935.GD8830@disturbed> <499BD6BB.2000406@aei.mpg.de> <20090219061925.GE8830@disturbed>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090219061925.GE8830@disturbed>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 19, 2009 at 05:19:25PM +1100, Dave Chinner wrote:
> On Wed, Feb 18, 2009 at 10:36:59AM +0100, Carsten Aulbert wrote:
> > >> plus a few more nodes showing the same characteristics 
> > > 
> > > Hmmmm. Did this show up in 2.6.27.10? Or did it start occurring only
> > > after you upgraded from .10 to .14?
> > 
> > As far as I can see this only happened after the upgrade about 14 days
> > ago. What strikes me odd is that we only had this occurring massively on
> > Monday and Tuesday this week.
> > 
> > I don't know if a certain access pattern could trigger this somehow.
> 
> I suspect so. We've already had XFS trigger one bug in the new
> lockless pagecache code, and the fix for that went in 2.6.27.11 -
> between the good version and the version that you've been seeing
> these memory corruptions on. I'm wondering if that fix exposed or
> introduced another bug that you've hit....

Highly unlikely. It only introduces constraints on how the
compiler may generate code, so it would have to be a compiler
bug to cause a bug I think.

I wonder how long you've been running with 2.6.27 based kernels
without corruption?
