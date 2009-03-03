Return-Path: <linux-kernel-owner+w=401wt.eu-S1755480AbZCCOyB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480AbZCCOyB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 09:54:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751897AbZCCOxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 09:53:51 -0500
Received: from kroah.org ([198.145.64.141]:41093 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751994AbZCCOxt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 09:53:49 -0500
Date: Tue, 3 Mar 2009 06:53:10 -0800
From: Greg KH <greg@kroah.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, wireless <linux-wireless@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Elaboration on "Equivalent fix must already exist in Linus'
	tree"
Message-ID: <20090303145310.GB5791@kroah.com>
References: <43e72e890903022143k83890afr6673753f52c5ff8@mail.gmail.com> <49ACC6B0.409@garzik.org> <43e72e890903022244j2b2f4276lf6e318f3dad3df@mail.gmail.com> <20090303072637.GB4440@kroah.com> <43e72e890903022337k5281a790j8641f93cce3f9c70@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43e72e890903022337k5281a790j8641f93cce3f9c70@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 02, 2009 at 11:37:33PM -0800, Luis R. Rodriguez wrote:
> On Mon, Mar 2, 2009 at 11:26 PM, Greg KH <greg@kroah.com> wrote:
> > - Show quoted text -
> > On Mon, Mar 02, 2009 at 10:44:40PM -0800, Luis R. Rodriguez wrote:
> >> On Mon, Mar 2, 2009 at 9:57 PM, Jeff Garzik <jeff@garzik.org> wrote:
> >> > Luis R. Rodriguez wrote:
> >> >>
> >> >> While extending the documentation for submitting Linux wireless bug
> >> >> reports [1] we note the stable series policy on patches -- that of
> >> >> having an equivalent fix already in Linus' tree. I find this
> >> >> documented in Documentation/stable_kernel_rules.txt but I'm curious if
> >> >> there is any other resource which documents this or elaborates on this
> >> >> a bit more. I often tell people about this rule or push _really_ hard
> >> >> on testing "upstream" but some people tend to not understand. I think
> >> >> that elaborating a little on this can help and will hopefully create
> >> >> more awareness around the importance of trees like Stephen's
> >> >> linux-next tree.
> >> >
> >> > Just have people google for GregKH's copious messages, telling people a fix
> >> > needs to be upstream before it goes into -stable.
> >> >
> >> > Typically you make things easy by emailing stable@kernel.org with a commit
> >> > id.
> >> >
> >> > There are only two exceptions:
> >> > * fix is upstream, but needs to be modified for -stable
> >> > * fix is not needed at all in upstream, but -stable still needs it
> >>
> >> This certainly helps, I'm also looking for good arguments to support
> >> the reasoning behind the policy so that not only will people follow
> >> this to help development but _understand_ it and so that they can
> >> themselves promote things like linux-next and realize why its so
> >> important. Mind you -- upstream for us in wireless for example is not
> >> Linus its John's tree so what we promote is not to get the fix first
> >> into Linus' tree but first into John's tree. Which is obvious to
> >> developers but perhaps not to others.
> >
> > Who are these "people" that you are trying to convince?
> 
> OK small silly example is convincing distributions it may be a good
> idea to carry linux-next kernel packages as options to users to
> hopefully down the road reduce the delta between what they carry and
> what is actually upstream.

Woah!

You started out talking about -stable, and now you are trying to use
that as a reason for a distro to carry -next?  Those are on the totally
different end of the spectrum.

It's up to the individual distros if they want to carry portions of
-next (and if you look, they all carry some parts, due to different
reasons).

thanks,

greg k-h
