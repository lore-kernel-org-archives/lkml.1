Return-Path: <linux-kernel-owner+w=401wt.eu-S1758420AbZCSSq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758420AbZCSSq5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 14:46:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753778AbZCSSqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 14:46:47 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:43247 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756AbZCSSqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 14:46:46 -0400
Date: Thu, 19 Mar 2009 18:44:12 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Joe Malicki <jmalicki@metacarta.com>
cc: chrisw@sous-sol.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] CRED: Fix check_unsafe_exec()
In-Reply-To: <9353728.11137281237331262320.JavaMail.root@ouachita>
Message-ID: <Pine.LNX.4.64.0903191839330.12886@blonde.anvils>
References: <9353728.11137281237331262320.JavaMail.root@ouachita>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Mar 2009, Joe Malicki wrote:
> ----- "Joe Malicki" <jmalicki@metacarta.com> wrote:
> > ----- "Hugh Dickins" <hugh@veritas.com> wrote:
> > > Yes, I'm inclined to go with that, and removing the files->count
> > > check from exec.c.  Joe, did you manage to try your testing with
> > > my original patch plus that files->count check removed from 2.6.28's
> > > unsafe_exec()?
> > 
> > Sorry for not responding earlier.
> > 
> > I still got one failure with this new patch.  I added some printks
> > to illuminate exactly why it's failing when it fails to setuid, but
> > of course, since adding the printks I haven't reproduced yet.
> 
> My tests were accidentally run without removing the files->count check.

Oh good, thanks Joe, I was hoping that would be the case.

> The printks confirmed the failure case was the files->count check,
> and removing the files->check has worked thus far (though I can't be
> sure until after a day or two has gone by given how infrequent it is).

Okay, unless we hear bad news from you later, I'll post the set of three
patches (removing the files->count check, then my original fs->count one,
plus David's comment) in a day or two, adding a few more Ccs.

Hugh
