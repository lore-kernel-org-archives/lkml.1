Return-Path: <linux-kernel-owner+w=401wt.eu-S1754683AbZGXV1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683AbZGXV1r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 17:27:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754668AbZGXV1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 17:27:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39791 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754642AbZGXV1p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 17:27:45 -0400
Date: Fri, 24 Jul 2009 14:13:52 -0700
From: Greg KH <gregkh@suse.de>
To: Krzysztof =?utf-8?Q?Ol=C4=99dzki?= <ole@ans.pl>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net
Subject: Re: Linux 2.6.27.27
Message-ID: <20090724211352.GB6077@suse.de>
References: <20090720040655.GA11940@kroah.com>
 <4A645A45.9060509@ans.pl>
 <20090720151008.GC10015@suse.de>
 <4A689EE3.3070405@ans.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4A689EE3.3070405@ans.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 23, 2009 at 07:33:23PM +0200, Krzysztof Olędzki wrote:
> On 2009-07-20 17:10, Greg KH wrote:
> > On Mon, Jul 20, 2009 at 01:51:33PM +0200, Krzysztof Oledzki wrote:
> >> On 2009-07-20 06:06, Greg KH wrote:
> >>> I'm announcing the release of the 2.6.27.26 kernel.  All users of the
> >>> 2.6.27 kernel series are very strongly encouraged to upgrade.
> >>>
> >>> I'll also be replying to this message with a copy of the patch between
> >>> 2.6.27.26 and 2.6.27.27
> >>>
> >>> The updated 2.6.27.y git tree can be found at:
> >>>        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.27.y.git
> >>> and can be browsed at the normal kernel.org git web browser:
> >>>        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.27.y.git;a=summary
> >>>
> >>> thanks,
> >> <CUT>
> >>> Linus Torvalds (1):
> >>>      Don't use '-fwrapv' compiler option: it's buggy in gcc-4.1.x
> >> I'm very sorry to say that but 2.6.27.27 compiled with gcc-4.2.4
> >> hangs during boot and it is caused by this fix.
> >>
> >> I extended http://bugzilla.kernel.org/show_bug.cgi?id=13012 with
> >> additional info & .config.
> > 
> > Wierd.  Linus, any thoughts?  Do we need to check the version of the
> > compiler that we are using before turning that option off?
> 
> This bug is now fixed by 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=3730793d457fed79a6d49bae72996d458c8e4f2d
> 
> Could you please include this patch in the next -stable releases?

Yes, I have it queued up to go out today :)

> BTW: the problem exists in gcc-4.2.4 not gcc-2.4.2 so I think it is 
> worth to change the subject when adding the patch. ;)

Hm, I'll see about that.

thanks,

greg k-h
