Return-Path: <linux-kernel-owner+w=401wt.eu-S1761815AbYGOOZE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761815AbYGOOZE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 10:25:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757607AbYGOOYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 10:24:51 -0400
Received: from wx-out-0506.google.com ([66.249.82.235]:23214 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756921AbYGOOYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 10:24:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=f+yh8pxSifuCJx5AxSlFNPIG1h27lyG1Ef1BLFMraeiC9/97nRcvR7CJY9ciNq7s2w
         H1qkFGq89v7oVrhC5J7W+cg5ORxDdp+aTk5MAbo1KBDyb3dR9YQivKLdknE7YEW76SIf
         rOfgQFJwH4PSgfnpG7GG0Q+p8oHsteDcg/OXI=
Date: Tue, 15 Jul 2008 18:24:44 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stoyan Gaydarov <stoyboyker@gmail.com>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, akpm@linux-foundation.org,
       mingo@elte.hu
Subject: Re: From 2.4 to 2.6 to 2.7?
Message-ID: <20080715142444.GA7121@asus>
References: <6d291e080807141910m573b29b2t753ea7c4db09902d@mail.gmail.com> <alpine.LFD.1.10.0807141914280.3017@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0807141914280.3017@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Linus Torvalds - Mon, Jul 14, 2008 at 07:22:04PM -0700]
| 
| 
| On Mon, 14 Jul 2008, Stoyan Gaydarov wrote:
| > 
| > Second I wanted to talk about the linux 2.7.x kernel, whats in the
| > making or maybe even not started
| 
| Nothing.
| 
| I'm not going back to the old model. The new model is so much better that 
| it's not even worth entertaining as a theory to go back.
| 
| That said, I _am_ considering changing just the numbering. Not to go back 
| to the old model, but because a constantly increasing minor number leads 
| to big numbers. I'm not all that thrilled with "26" as a number: it's hard 
| to remember.
| 
| So I would not dismiss (and have been thinking about starting) talk about 
| a simple numbering reset (perhaps yearly), but the old model of 3-year 
| developement trees is simply not coming back as far as I'm concerned.
| 
| In fact, I think the time-based releases (ie the "2 weeks of merge window 
| until -rc1, followed by roughly two months of stabilization") has been so 
| successful that I'd prefer to skip the version numbering model too. We 
| don't do releases based on "features" any more, so why should we do 
| version _numbering_ based on "features"?
| 
| For example, I don't see any individual feature that would merit a jump 
| from 2.x to 3.x or even from 2.6.x to 2.8.x. So maybe those version jumps 
| should be done by a time-based model too - matching how we actually do 
| releases anyway.
| 
| So if the version were to be date-based, instead of releasing 2.6.26, 
| maybe we could have 2008.7 instead. Or just increment the major version 
| every decade, the middle version every year, and the minor version every 
| time we make a release. Whatever.
| 
| But three-year development trees with a concurrent stable tree? Nope. Not 
| going to happen.
| 
| 		Linus
| 

Hi to all! Since I've been Cc'ed :) I think I'm not the right person
to be asked about numbering scheme (and since I'm not that long in
kernel) BUT actually I think there is only one question - it's not
about how to number the kernel but rather what we trying to say by
numbering scheme. Some areas should be distinguished:

	- development/stable team
	- distros
	- regular users

Most developers work with git trees and rather carries about sha1 then
a version number :) So eventually numbering scheme is not that important
for developers by its own.

Distros - well, i think distros use they own scheme anyway so they don't
really care about kernel versioning scheme (Gentoo-2008, Fedora-9, Ubuntu-8.04...)

So we have the quite large group of people which should be considered for
convenient versioning scheme - _regular users_. Lets say I'm a regular user -
the most convenient scheme for me would be YYYY.r.s i think since it tells
me - this kernel is fresh enough to be used on my shining laptop, and maybe
it even supports all hardware I have! And at least it looks good -

	Linux-2008.0.0

but personally i don't really care that much :)

		- Cyrill -
