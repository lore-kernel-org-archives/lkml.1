Return-Path: <linux-kernel-owner+w=401wt.eu-S1751569AbZEZNLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751569AbZEZNLt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 09:11:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751044AbZEZNLl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 09:11:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:49150 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbZEZNLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 09:11:40 -0400
Date: Tue, 26 May 2009 08:16:44 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, xemul@parallels.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 18/38] C/R: core stuff
Message-ID: <20090526131644.GA20920@hallyn.com>
References: <1242968132-1044-1-git-send-email-adobriyan@gmail.com> <1242968132-1044-18-git-send-email-adobriyan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242968132-1044-18-git-send-email-adobriyan@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Alexey Dobriyan (adobriyan@gmail.com):
> Introduction
> ------------
> Checkpoint/restart (C/R from now) allows to dump group of processes to disk
> for various reasons like saving process state in case of box failure or
> restoration of group of processes on another or same machine later.
> 
> Unlike, let's say, hypervisor C/R style which only needs to freeze guest kernel
> and dump more or less raw pages, proposed C/R doesn't require hypervisor.
> For that C/R code needs to know about all little and big intimate kernel details.
> 
> The good thing is that not all details needs to be serialized and saved
> like, say, readahead state. The bad things is still quite a few things
> need to be.

Hi Alexey,

the last time you posted this, I went through and tried to discern the
meaningful differences between yours and Oren's patchsets.  Then I sent some
patches to Oren to make his set configurable to act more like yours.  And Oren
took them!  But now you resend this patchset with no real changelog, no
acknowledgment that Oren's set even exists - or is much farther along and
pretty widely reviewed and tested (which is only because he started earlier
and, when we asked for your counterpatches at an earlier stage, you would never
reply) - or, most importantly, what it is that you think your patchset does
that his does not and cannot.  *Why* are you spending your time on this instead
of helping with Oren's set?  The code really isn't all that different...  Maybe
you just think that two independently written patchsets will expose more
gotchas that we'll need to catch, so you're continuing on this effort under the
expectation that eventualy we'll merge the two sets?

Honestly, I have great respect for your coding abilities.  And if 'voices
from on high' tell us to base upon your code, I'd be fine with that, I
have no real problems with what I see on yet another cursory look.  But
given the amount of collective time that's been spent developing, reviewing,
and testing Oren's set, it wouldn't make any sense to just jump.  So
I'd still just like to know how you see this proceeding.

thanks,
-serge
