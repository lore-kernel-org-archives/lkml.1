Return-Path: <linux-kernel-owner+w=401wt.eu-S933754AbZJORwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933754AbZJORwz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 13:52:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754616AbZJORwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 13:52:55 -0400
Received: from cantor.suse.de ([195.135.220.2]:60673 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754857AbZJORwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 13:52:54 -0400
Date: Thu, 15 Oct 2009 10:49:32 -0700
From: Greg KH <gregkh@suse.de>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: david@lang.hm, Stefan Richter <stefanr@s5r6.in-berlin.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: removing existing working drivers via staging
Message-ID: <20091015174932.GA3595@suse.de>
References: <alpine.DEB.2.00.0910142213590.22169@asgard.lang.hm>
 <alpine.DEB.2.00.0910150936310.22169@asgard.lang.hm>
 <20091015164726.GA10125@suse.de>
 <200910151942.40259.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910151942.40259.bzolnier@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 15, 2009 at 07:42:40PM +0200, Bartlomiej Zolnierkiewicz wrote:
> On Thursday 15 October 2009 18:47:26 Greg KH wrote:
> > On Thu, Oct 15, 2009 at 09:39:51AM -0700, david@lang.hm wrote:
> > > however, what I think I saw proposed was to move drivers that need to be 
> > > 'cleaned up', to staging and then dropping them if they don't get cleaned.
> > 
> > What is "proposed" is the following:
> > 
> > 	- For drivers currently in the kernel tree, that the subsystem
> > 	  maintainer, for whatever reason, feels is obsolete / broken /
> > 	  needs major cleaning / wants to get rid of, can be submitted
> > 	  to the staging maintainer to be moved to the drivers/staging/
> > 	  directory.
> 
> This is insanity and opens a door for various forms of abuse.

What do you mean by this?  What kind of "abuse"?
