Return-Path: <linux-kernel-owner+w=401wt.eu-S1757026AbYH2UoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757026AbYH2UoV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 16:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753452AbYH2UoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 16:44:10 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:13646 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371AbYH2UoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 16:44:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=ceAeYdwo19pRv2V41t2FUpKzekvCYbYDghBIumww56R5VWEPd3rGctlm6M4Ku/sR6l
         ZUSDDv1WtXtXahaW4l15wSgAsb9JDG0vnOvZK+F6d3gfVI9cIobeF54p/YjP0FVV1592
         f5zoDw/+zmLRdlKBw/lpeH7p8HlfvJPjjvAdU=
Message-ID: <cfd18e0f0808291344g6c96a626x952a0016d3178053@mail.gmail.com>
Date: Fri, 29 Aug 2008 22:44:08 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Reply-To: mtk.manpages@gmail.com
To: "Ulrich Drepper" <drepper@redhat.com>
Subject: Re: No NONBLOCK flag for dup3() or epoll_create1()?
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Al Viro" <viro@zeniv.linux.org.uk>,
       lkml <linux-kernel@vger.kernel.org>,
       "Davide Libenzi" <davidel@xmailserver.org>
In-Reply-To: <48AC4B19.6000206@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48AC4B19.6000206@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping!

On Wed, Aug 20, 2008 at 6:49 PM, Michael Kerrisk
<mtk.manpages@googlemail.com> wrote:
> Ulrich
>
> I've been doing some testing (2.6.27-rc3) of your new
> file-descriptor-creating syscalls that accept flags.  According to
>
> http://udrepper.livejournal.com/20407.html
>
> all of the system calls should accept a *_NONBLOCK flag.  All of them do,
> except for two:
> dup3(olfd, newfd, flags)
> and
> epoll_create1(flags).
>
> For epoll_create1() this certainly appears to be an oversight, since I can't
> think of a reason not to support *_NONBLOCK.
>
> For dup3() it is perhaps also an oversight.  However, it's not really clear
> to me whether supporting O_NONBLOCK makes sense, since that would change the
> file status flags of the open file description that is (also) referred to by
> oldfd.  (Furthermore, given a open file description for which O_NONBLOCK is
> already enabled, it is not possible to make a dup3() call that disables
> O_NONBLOCK, which is an odd asymmetry in the API.)  What are your thoughts
> on
> this?
>
> Cheers,
>
> Michael
>
>



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
