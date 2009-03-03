Return-Path: <linux-kernel-owner+w=401wt.eu-S1758879AbZCCH1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758879AbZCCH1d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 02:27:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755994AbZCCH1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 02:27:21 -0500
Received: from kroah.org ([198.145.64.141]:44357 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758010AbZCCH1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 02:27:19 -0500
Date: Mon, 2 Mar 2009 23:26:37 -0800
From: Greg KH <greg@kroah.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, wireless <linux-wireless@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Elaboration on "Equivalent fix must already exist in Linus'
	tree"
Message-ID: <20090303072637.GB4440@kroah.com>
References: <43e72e890903022143k83890afr6673753f52c5ff8@mail.gmail.com> <49ACC6B0.409@garzik.org> <43e72e890903022244j2b2f4276lf6e318f3dad3df@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43e72e890903022244j2b2f4276lf6e318f3dad3df@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 02, 2009 at 10:44:40PM -0800, Luis R. Rodriguez wrote:
> On Mon, Mar 2, 2009 at 9:57 PM, Jeff Garzik <jeff@garzik.org> wrote:
> > Luis R. Rodriguez wrote:
> >>
> >> While extending the documentation for submitting Linux wireless bug
> >> reports [1] we note the stable series policy on patches -- that of
> >> having an equivalent fix already in Linus' tree. I find this
> >> documented in Documentation/stable_kernel_rules.txt but I'm curious if
> >> there is any other resource which documents this or elaborates on this
> >> a bit more. I often tell people about this rule or push _really_ hard
> >> on testing "upstream" but some people tend to not understand. I think
> >> that elaborating a little on this can help and will hopefully create
> >> more awareness around the importance of trees like Stephen's
> >> linux-next tree.
> >
> > Just have people google for GregKH's copious messages, telling people a fix
> > needs to be upstream before it goes into -stable.
> >
> > Typically you make things easy by emailing stable@kernel.org with a commit
> > id.
> >
> > There are only two exceptions:
> > * fix is upstream, but needs to be modified for -stable
> > * fix is not needed at all in upstream, but -stable still needs it
> 
> This certainly helps, I'm also looking for good arguments to support
> the reasoning behind the policy so that not only will people follow
> this to help development but _understand_ it and so that they can
> themselves promote things like linux-next and realize why its so
> important. Mind you -- upstream for us in wireless for example is not
> Linus its John's tree so what we promote is not to get the fix first
> into Linus' tree but first into John's tree. Which is obvious to
> developers but perhaps not to others.

Who are these "people" that you are trying to convince?  If they aren't
developers, why would any "others" care about our development
proceedures?

Heck, very few developers even read the Documentation files, I'd never
expect an "other" to do that :)

thanks,

greg k-h
