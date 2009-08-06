Return-Path: <linux-kernel-owner+w=401wt.eu-S1754999AbZHFWdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999AbZHFWdZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 18:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754818AbZHFWdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 18:33:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46126 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754802AbZHFWdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 18:33:24 -0400
Date: Thu, 6 Aug 2009 15:32:05 -0700
From: Greg KH <gregkh@suse.de>
To: Andreas Mohr <andi@lisas.de>, Kay Sievers <kay.sievers@vrfy.org>
Cc: Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org,
       rusty@rustcorp.com.au
Subject: Re: [BUG] git 2.6.31-rc3'ish: "<kobject> does not have a release()
 function, it is broken and must be fixed."
Message-ID: <20090806223205.GD14792@suse.de>
References: <20090716181256.GA11157@rhlx01.hs-esslingen.de>
 <20090716225525.GC1548@suse.de>
 <adabpmsg01a.fsf@cisco.com>
 <20090806205019.GA12988@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090806205019.GA12988@rhlx01.hs-esslingen.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 06, 2009 at 10:50:19PM +0200, Andreas Mohr wrote:
> Hi,
> 
> On Thu, Aug 06, 2009 at 01:28:01PM -0700, Roland Dreier wrote:
> > ie a ktype with no release method.  And indeed, the release method was
> > removed in:
> > 
> > commit 7a6a41615bfb2f03ce797bc24104c50b42c935e5
> > Author: Greg Kroah-Hartman <gregkh@suse.de>
> > Date:   Sat Dec 22 21:18:25 2007 -0800
> > 
> >     Modules: remove unneeded release function
> > 
> > ie you did it yourself!
> > 
> > What's the deal?
> 
> Oh I'm sure it was a cunning way of deluding oneself, and the entire
> global community on top of it, too! ;)
> Else it must have been successful sabotage by a certain M$ collaborator
> employee I'd wager :)
> 
> Many thanks for taking part in this issue, thanks to you it sounds like we're
> rather close to a solution now...

Odd, I really have no idea what was going on 2 years ago in this area,
sorry.

Kay, we were cleaning up the kobject name stuff then, and we thought
that this release function wasn't used anymore.  But in looking at the
code, I can't see where the kobject is actually freed.  What am I
missing?

confused,

greg k-h

> 
> Andreas Mohr
