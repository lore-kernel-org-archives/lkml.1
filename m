Return-Path: <linux-kernel-owner+w=401wt.eu-S1753816AbYE3Q7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816AbYE3Q7Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 12:59:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752504AbYE3Q7B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 12:59:01 -0400
Received: from outbound-mail-33.bluehost.com ([69.89.18.153]:33411 "HELO
	outbound-mail-33.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752314AbYE3Q7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 12:59:00 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: dri-devel@lists.sourceforge.net
Subject: Re: in-kernel DRM tree move around....
Date: Fri, 30 May 2008 09:58:53 -0700
User-Agent: KMail/1.9.9
Cc: "Dave Airlie" <airlied@gmail.com>,
       "kernel list" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <21d7e9970805281746k71b47ed2i79c06288d2dca022@mail.gmail.com> <1212058935.26088.11.camel@shinybook.infradead.org> <21d7e9970805292326m1a238aa1id8b6733351ba15d3@mail.gmail.com>
In-Reply-To: <21d7e9970805292326m1a238aa1id8b6733351ba15d3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805300958.53361.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 29, 2008 11:26 pm Dave Airlie wrote:
> On Thu, May 29, 2008 at 9:02 PM, David Woodhouse <dwmw2@infradead.org> 
wrote:
> > On Thu, 2008-05-29 at 10:46 +1000, Dave Airlie wrote:
> >> Hi,
> >>
> >> So I've been growing more annoyed with the current layout of the drm
> >> tree in the kernel,
> >>
> >> a) it lives under char.
> >> b) everything in one directory.
> >> c) header files in one directory.
> >> d) no header files exposed to userspace.
> >>
> >> http://git.kernel.org/?p=linux/kernel/git/airlied/drm-2.6.git;a=commitdi
> >>ff;h=7df9a948d0f849466e3de259cccb49bc54cbad68
> >>
> >> is a proposal to create drivers/gpu/drm, (I may move AGP in there as
> >> well later). It also creates per-driver subdirs.
> >
> > Looks sane from the header export POV. Passes headers_check and doesn't
> > add any more instances of CONFIG_xxx visible to userspace (I'm coming
> > after those, soon).
>
> So assuming I fixed up the kbuild issues, any ideas on when it would
> be a good plan to upstream this sorta major movement.
>
> Not many DRM patches don't come via me, and I can fix up the ones that
> do before I merge them.
>
> Linus? any ideas on when you would prefer to take a tree like this?
> start of rc1?

Yes please, as soon as the merge window opens.  Now if we could just convince 
you to host a full kernel tree for DRM development, with a separate, 
symlinked BSD dir at the top level, we'd be all set. :)

Jesse
