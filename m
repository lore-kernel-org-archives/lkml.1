Return-Path: <linux-kernel-owner+w=401wt.eu-S1756106AbYICSiI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106AbYICSiI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 14:38:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753765AbYICSh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 14:37:56 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37883 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753498AbYICSh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 14:37:56 -0400
Date: Wed, 3 Sep 2008 14:37:46 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Roland McGrath <roland@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] utrace
Message-ID: <20080903183746.GA16175@infradead.org>
References: <20080826220102.89635154233@magilla.localdomain> <20080826223402.GB27724@x200.localdomain> <y0m7ia3xqev.fsf@ton.toronto.redhat.com> <20080827135453.GA31240@infradead.org> <20080827164055.GA22236@in.ibm.com> <20080830134057.GB17566@infradead.org> <20080903120927.3C1FF154228@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080903120927.3C1FF154228@magilla.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2008 at 05:09:27AM -0700, Roland McGrath wrote:
> I have spent a lot of time keeping the patch series up to date,
> rebasing, etc.  This has sunk all the time that I'd like to have been
> spending working on higher-level pieces such as the ntrace idea.
> 
> (This will be much better now that all the tracehook work is in 2.6.27.
> I know you don't buy the rationale I've explained for that work.  But I
> am confident that having this in is a substantial and immediate boon to
> the ease and efficiency of getting more work done sooner in this area.)

Yes, now you've got all the lowlevel bits in that should have been
long time ago :)  And you don;t have to rebase it all the time if you
don't have time for it.  Keep developing ntrace on one major release and
then you can forward-port the whole bunch at once less frequently.

> At the same time, many of the people who have asked me about the state
> of the effort say things to the effect that they would like to try
> writing some features based on such an API once it's been merged in.

Then the people should help with the upstream process, post their bits
to lkml, help you with forward-porting, etc.

