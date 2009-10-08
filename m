Return-Path: <linux-kernel-owner+w=401wt.eu-S1758021AbZJHMtN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758021AbZJHMtN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 08:49:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757187AbZJHMtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 08:49:13 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:57122 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755871AbZJHMtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 08:49:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RdoxGU3ZzQQwFuCR/iR1rsvICpRC0UoPv/NCNMx1OTLutpeRezQX7o6Qq44lU61lHN
         37lXTQTuAqQSVPci2YYSGBUXFExicb/J64lDKii75YhaFEpFu4Je1qHdG1XYeEceFlrf
         MekmaJ8Vi+PQMhCpgcrrzAksuGxUqhKjbp/Lg=
Date: Thu, 8 Oct 2009 14:48:24 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
       linux-kernel@vger.kernel.org, hch@infradead.org,
       reiserfs-devel@vger.kernel.org, jeffm@suse.com
Subject: Re: [PATCH] reiserfs: Truncate blocks not used by a write (v2)
Message-ID: <20091008124818.GB5073@nowhere>
References: <1253121912-20718-1-git-send-email-jack@suse.cz> <20090916144815.e544b319.akpm@linux-foundation.org> <20090917005633.GC8098@nowhere> <20090917115629.6f8f8f00.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090917115629.6f8f8f00.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 11:56:29AM +1000, Stephen Rothwell wrote:
> Hi Frederic,
> 
> On Thu, 17 Sep 2009 02:56:34 +0200 Frederic Weisbecker <fweisbec@gmail.com> wrote:
> >
> > Note that the kill-the-bkl/reiserfs tree has suffered from too much
> > lock inversion problems lately. Even though I just fixed the last one
> > reported, I would feel more comfortable to schedule this tree for .33
> > rather than .32
> > 
> > So this tree can be removed from -next and reintegrated once -rc1 is
> > released, without problem.
> 
> OK, I have removed it from today.  Please let me know when it should be
> readded (in case I forget - which at my age is likely :-)).


Hi Stephen,

Now that -rc1 has been released (well.. -rc2, or..hmm...), could you please
reintegrate the tree:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	reiserfs/kill-bkl

into -next ?

It is based on linux-2.6.31, I haven't merged 32-rc3 into
it because there is no conflict between those and there are no
dependencies against latest changes.

Tell me if you need something. It's possible there are pending
patches in reiserfs for .33 in -next which might conflict, I don't
know. But if you need help to fix the conflicts, just tell me.

Thanks!
	

