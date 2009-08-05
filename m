Return-Path: <linux-kernel-owner+w=401wt.eu-S933765AbZHEIJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933765AbZHEIJB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 04:09:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933523AbZHEII7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 04:08:59 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:55131 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933236AbZHEII6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 04:08:58 -0400
Date: Wed, 5 Aug 2009 10:08:58 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Dave Airlie <airlied@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: ftrace scripts and make V=1
Message-ID: <20090805080858.GA2947@merkur.ravnborg.org>
References: <21d7e9970908050023j2807ef3bi1321ac2a1fd9a743@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21d7e9970908050023j2807ef3bi1321ac2a1fd9a743@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 05, 2009 at 05:23:26PM +1000, Dave Airlie wrote:
> Hey,
> 
> So I spent 3-4 hrs today (I'm stupid yes) tracking down a .o breakage by
> blaming rawhide gcc/binutils as I was using make V=1and seeing only the
> compiler chain running,
> 
> However some ftrace script was sneaking in afterwards
> and screwing up the .o without mentioning itself.
> 
> Surely V=1 should print all these shitty scripts its running?

The problem is that V=1 is already too chatty,
so people sometimes hide their stuff - as in this case.

I have for some time thought about adding some option
so we can select between:
 - less chatty than today - but print the usefull stuff
 - full debug - print almost everything

It is not that this is hard to implment.
But I never have made up my mind how to enable this.

V=1 - could be the "less chatty" mode
V=2 - could be the "full debug mode"

But we already use "V=2" to tell what caused a file to be rebuild.
This is on the other hand very seldomly used so we could get
away with a new way to request this.
So we limit V=n to select between different verbosity levels.

What do you think?

	Sam
