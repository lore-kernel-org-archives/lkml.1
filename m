Return-Path: <linux-kernel-owner+w=401wt.eu-S1754744AbZAFWFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744AbZAFWFr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:05:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751572AbZAFWFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:05:38 -0500
Received: from wf-out-1314.google.com ([209.85.200.172]:13881 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbZAFWFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:05:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=hc/tYfOc22IF48W8AqHxkGcLAfqSQ343pHLeaNwav0f2Bl6TKQPq2bSyakypSHJ8FI
         UJozwXQ1y3tbhXkflgYTGb3wuPDPPsHsIDmPD/YVokq3T4NRPr3ZsQJt10i4WZG2CgDj
         hdB9HYTQWLa9yKWPp3Ecgnj1+55O7AZsoMg5Q=
Subject: Re: [PATCH 03/23] cris: introduce asm/swab.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesper Nilsson <jesper.nilsson@axis.com>
In-Reply-To: <alpine.LFD.2.00.0901061357150.3057@localhost.localdomain>
References: <1231277446.964.260.camel@brick>
	 <alpine.LFD.2.00.0901061357150.3057@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 06 Jan 2009 14:04:12 -0800
Message-Id: <1231279452.25147.1.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-06 at 13:59 -0800, Linus Torvalds wrote:
> 
> On Tue, 6 Jan 2009, Harvey Harrison wrote:
> >
> > cris holds its arch overrides in an arch/ folder, rename these
> > byteorder.h files to swab.h and include them from asm/swab.h
> > 
> > Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> > ---
> >  arch/cris/include/arch-v10/arch/byteorder.h |   28 ---------------------------
> >  arch/cris/include/arch-v10/arch/swab.h      |   28 +++++++++++++++++++++++++++
> >  arch/cris/include/arch-v32/arch/byteorder.h |   22 ---------------------
> >  arch/cris/include/arch-v32/arch/swab.h      |   22 +++++++++++++++++++++
> 
> 
> Since you'e a git user, and you're basically renaming files while then 
> putting a new name in place, can you please send patches done with both 
> the "-M" flag (rename detection) _and_ the "-B" flag (which breaks 
> associations of files even if the name stays the same)?
> 
> It's rare that this is needed, but it really helps. Now the patches look 
> like a big delete/create event, and it's not at all obvious that the code 
> is actually the same before and after.

Sure, I sent regular patches as a courtesy to Andrew in case he slurped
it up, but I can resend with -M -B if you're going to take it directly,
should I wait until I see the remaining 4 arches hit your tree, or will
you worry about the timing?

Harvey

