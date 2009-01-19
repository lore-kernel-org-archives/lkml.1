Return-Path: <linux-kernel-owner+w=401wt.eu-S1756910AbZASBSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910AbZASBSx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 20:18:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755538AbZASBSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 20:18:42 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:49983 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754414AbZASBSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 20:18:41 -0500
Date: Mon, 19 Jan 2009 02:20:24 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL -tip] fix 41 'make headers_check' warnings
Message-ID: <20090119012024.GA4491@uranus.ravnborg.org>
References: <1232273454.23100.9.camel@localhost.localdomain> <20090119093959.ef7f2495.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090119093959.ef7f2495.sfr@canb.auug.org.au>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2009 at 09:39:59AM +1100, Stephen Rothwell wrote:
> Hi Jaswinder,
> 
> On Sun, 18 Jan 2009 15:40:54 +0530 Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> >
> > diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> > index 5571dbe..81fa255 100644
> > --- a/include/linux/videodev2.h
> > +++ b/include/linux/videodev2.h
> > @@ -1480,7 +1480,7 @@ struct v4l2_chip_ident_old {
> >  
> >  #if 1
> >  /* Experimental, meant for debugging, testing and internal use.
> > -   Only implemented if CONFIG_VIDEO_ADV_DEBUG is defined.
> > +   Only implemented if VIDEO_ADV_DEBUG is defined.
> >     You must be root to use these ioctls. Never use these in applications! */
> 
> Is there some reason we cannot fix the tool that does the checking for
> this case?

It could be done - but for now I have kept it very simple.
One day I should preprocess the headers or something to cover more
issues.

	Sam
