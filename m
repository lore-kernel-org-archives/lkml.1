Return-Path: <linux-kernel-owner+w=401wt.eu-S1753087AbZI3Gxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087AbZI3Gxa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 02:53:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752299AbZI3Gx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 02:53:29 -0400
Received: from [195.41.46.235] ([195.41.46.235]:47263 "EHLO pfepa.post.tele.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751654AbZI3Gx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 02:53:28 -0400
Date: Wed, 30 Sep 2009 08:53:26 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andreas Schwab <schwab@redhat.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Tim Abbott <tabbott@ksplice.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Roman Zippel <zippel@linux-m68k.org>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] m68k: Cleanup linker scripts using new linker
	script macros.
Message-ID: <20090930065326.GA13850@merkur.ravnborg.org>
References: <1253119466-19488-1-git-send-email-tabbott@ksplice.com> <1253119466-19488-3-git-send-email-tabbott@ksplice.com> <10f740e80909270258o6bde0f3dk720bd5b5c091ed2f@mail.gmail.com> <m2ocowwngg.fsf@igel.home> <alpine.DEB.1.10.0909271351110.14151@dr-wily.mit.edu> <m3zl8dbron.fsf@hase.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3zl8dbron.fsf@hase.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 29, 2009 at 07:12:56PM +0200, Andreas Schwab wrote:
> Tim Abbott <tabbott@ksplice.com> writes:
> 
> > Below is a new version of the second patch that attempts to address this 
> > by putting the ALIGN inside a section, so that _end is at the end of the 
> > load segment (I also did a bit more cleanup):
> >
> >   .init_end : {
> > 	/* This ALIGN be in a section so that _end is at the end of the
> > 	   load segment. */
> > 	. = ALIGN(PAGE_SIZE);
> > 	__init_end = .;
> >   }
> >   
> >   _end = .;
> 
> This works fine.

Thanks for testing Andreas.

Geert - I assume you take the corrected version and push to Linus?

	Sam
