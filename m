Return-Path: <linux-kernel-owner+w=401wt.eu-S1754883AbYDXVKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883AbYDXVKu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 17:10:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752398AbYDXVKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 17:10:42 -0400
Received: from wr-out-0506.google.com ([64.233.184.237]:64607 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272AbYDXVKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 17:10:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dlzEnPLNtsiFNQlREaN3Dk4WWW5D72NbQfOa3kjy3pCbG8KCWYVJqeZVLNueLBlUuaeBPXMFEDVOnelA46S+sNjGHdDAcGXNLGstkc5g9hAKHThDnG5O2SZe4lG1/NlBIm86e4rlqG+HLwFpc0s3LN5eZoR2s1zYmUh1GuN9i/w=
Message-ID: <dd18b0c30804241410q7514aa95v11b242d5bcf7da1d@mail.gmail.com>
Date: Thu, 24 Apr 2008 21:10:39 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: Regression: starting X locks box with git master
Cc: "James Cloos" <cloos@jhcloos.com>, linux-kernel@vger.kernel.org
In-Reply-To: <86802c440804241352v2623222bt28129a2c501cff25@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <m3hcdrqb03.fsf@lugabout.jhcloos.org>
	 <86802c440804241352v2623222bt28129a2c501cff25@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2008 at 8:52 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> On Thu, Apr 24, 2008 at 12:59 PM, James Cloos <cloos@jhcloos.com> wrote:
>  > 3dc5063786b273f1aee545844f6bd4e9651ebffe was current when I compiled.
>  >
>  >  With that kernel, my laptop locks up as soon as I startx.
>  >
>  >  The Xorg.0.log showed that the radeon driver got as far as starting
>  >  the i2c calls to the M7 video card.
>  >
>  >  After that the box would reply to ICMP pings and SysRq-B, but was
>  >  otherwise non-responsive.  Even SysRq-[KSU] seemed to do nothing.
>  >
>  >  v2.6.25 works fine.
>  >
>  >  There are 3562 commits (including merges) between those two, and
>  >  it takes an hour or more for each kernel compile.  Bisecting will
>  >  be quite painful.  And I only have the one box to work on.  But I
>  >  will see what I can do.
>  >
>  >  Posting before bisecting in case it helps anyone else....
>
>  Do you have CONFIG_X86_PAT in your .config?
>
>  YH
>
>
> --
>  To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>  the body of a message to majordomo@vger.kernel.org
>  More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  Please read the FAQ at  http://www.tux.org/lkml/
>
I cant seem to find X86_PAT,
I have mtrr to "y", but for the other dependencie NONPROMISC_DEVMEM I
cant seem to locate.
regards;


-- 
Justin P. Mattock
