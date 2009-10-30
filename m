Return-Path: <linux-kernel-owner+w=401wt.eu-S1756995AbZJ3LfK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756995AbZJ3LfK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 07:35:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756045AbZJ3LfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 07:35:10 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:59759 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755020AbZJ3LfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 07:35:09 -0400
Date: Fri, 30 Oct 2009 12:35:12 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Tim Abbott <tabbott@ksplice.com>
Cc: Greg Ungerer <gerg@snapgear.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 7/7] m68knommu: Split the .init section into
	INIT_TEXT_SECTION and INIT_DATA_SECTION.
Message-ID: <20091030113512.GB26667@merkur.ravnborg.org>
References: <alpine.DEB.1.10.0910142041520.6638@dr-wily.mit.edu> <1255886635-17371-7-git-send-email-tabbott@ksplice.com> <4AEA3DC9.7080205@snapgear.com> <alpine.DEB.1.10.0910292116511.24830@dr-wily.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0910292116511.24830@dr-wily.mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 29, 2009 at 09:30:37PM -0400, Tim Abbott wrote:
> On Fri, 30 Oct 2009, Greg Ungerer wrote:
> 
> > Hi Tim,
> > 
> > The whole series applied and ran fine for me!
> > (Of course excepting the define name clash in 1/7)
> 
> Thanks for your patience debugging this patch series!
> 
> > Do you want me to push these into m68knommu.git?
> 
> Yes, that'd be great.  Do you expect these to end up in 2.6.32?  I have an 
> API change to INIT_DATA_SECTION that I want to put in 2.6.32 to fix a tiny 
> regression on blackfin, and I'd like to know which change is likely to get 
> merged first (since the API change will likely conflict).

Let's postpone this fix until merge window opens.
I doubt it has any real effect anyway.

And I'm glad the m68knommu stuff is fixed now.

	Sam
