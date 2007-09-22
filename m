Return-Path: <linux-kernel-owner+w=401wt.eu-S1759238AbXIVCdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759238AbXIVCdd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 22:33:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754009AbXIVCdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 22:33:24 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:63630 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655AbXIVCdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 22:33:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=nrUvPJp9f2aqRCFc7kTQozydFUtuk+oJ2yF4NZd8GGkySF+pjn4UmSAPQ+c+af+1d8leFdm4qr4QYPbYT0qYhklVQdfUrS07XQmew5dKc5oI+g/s7zEjvH5IGkHojSLQzmYIcJXHcRSwKvmnANBtT0iUw6B4PAU/iFWTz2lx/xg=
Date: Sat, 22 Sep 2007 10:29:32 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Dave Haywood <tla@oak.selfip.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: linux 2.6.23-rc7 - 14 compile warnings
Message-ID: <20070922022932.GC2480@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <46F39004.4050106@oak.selfip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F39004.4050106@oak.selfip.net>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2007 at 10:33:56AM +0100, Dave Haywood wrote:
>Contents:
>	ver_linux output
>	Summary of compile warnings
>	Full compile log
>	.config
>
>============================
>
>Linux s1 2.6.23-rc7-g335fb8fc #9 SMP Fri Sep 21 09:31:01 BST 2007 i686 Pentium III (Coppermine) GenuineIntel GNU/Linux
>
>Gnu C                  4.2.0
>Gnu make               3.81
>binutils               2.17
>util-linux             2.12r
>mount                  2.12r
>module-init-tools      3.2.2
>e2fsprogs              1.40.2
>PPP                    2.4.4
>Linux C Library        2.5
>Dynamic linker (ldd)   2.5
>Procps                 3.2.7
>Net-tools              1.60
>Kbd                    1.12
>Sh-utils               6.9
>udev                   114
>
>============================
>
>Summary:
>  CC      mm/slub.o
>mm/slub.c: In function 'kfree':
>mm/slub.c:2491: warning: passing argument 3 of 'slab_free' discards
>qualifiers from pointer target type
>
>  CC      fs/autofs4/symlink.o
>fs/autofs4/symlink.c: In function 'autofs4_follow_link':
>fs/autofs4/symlink.c:18: warning: passing argument 2 of 'nd_set_link'
>discards qualifiers from pointer target type

These two warnings are suspicious. Explicit casts are already there, how
they come out? Or gcc bugs?

{snip}

