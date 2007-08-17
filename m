Return-Path: <linux-kernel-owner+w=401wt.eu-S1760520AbXHQFVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760520AbXHQFVT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 01:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754468AbXHQFVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 01:21:11 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:25120 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024AbXHQFVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 01:21:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oh0aB2G6LqFQebQuNEi3mrxxVH/2stQcmNfZKv1A6WrP/iwCzvJMdWMkyJC0tmcV06/jxlLgXeK49Gzg4zCnVVwt3XSu8GI22wNTe8HrfBVy7pAQufdtU6uaojZpFWjb+esvb+Gf5n8q59E45ipRP7VkZ4q7uhAzWQ7UKyhfCrw=
Message-ID: <653402b90708162221t1081650doe3efc976377b26cf@mail.gmail.com>
Date: Fri, 17 Aug 2007 07:21:08 +0200
From: "Miguel Ojeda" <maxextreme@gmail.com>
To: "Joe Perches" <joe@perches.com>
Subject: Re: [PATCH] [120/2many] MAINTAINERS - CFAG12864BFB LCD FRAMEBUFFER DRIVER
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <1187326515.822.25.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46bff946.crSIrCRHeVaUjuwb%joe@perches.com>
	 <653402b90708160216k1ea20490k7a846bd019e44b3d@mail.gmail.com>
	 <1187272507.5906.80.camel@localhost>
	 <653402b90708162137r6079d431ud91216bb7b140610@mail.gmail.com>
	 <1187326515.822.25.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/17/07, Joe Perches <joe@perches.com> wrote:
> On Fri, 2007-08-17 at 06:37 +0200, Miguel Ojeda wrote:
> > On 8/16/07, Joe Perches <joe@perches.com> wrote:
> > > On Thu, 2007-08-16 at 11:16 +0200, Miguel Ojeda wrote:
> > > > I think you could add also:
> > > >  +F:     Documentation/auxdisplay/cfag12864bfb
> > does not exist. I meant
> >    Documentation/auxdisplay/cfag12864b
> > As Documentation/auxdisplay/cfag12864b describes both at the same
> > time, it is OK to add them in both entries.
> > Sorry for the mistake.
>
> No worries.  We all make a bunch of 'em.
>
> This is what I have now:
>
> CFAG12864B LCD DRIVER
> P:      Miguel Ojeda Sandonis
> M:      maxextreme@gmail.com
> L:      linux-kernel@vger.kernel.org
> W:      http://auxdisplay.googlepages.com/
> S:      Maintained
> F:      Documentation/auxdisplay/cfag12864b
> F:      drivers/auxdisplay/cfag12864b.c
> F:      include/linux/cfag12864b.h
>
> CFAG12864BFB LCD FRAMEBUFFER DRIVER
> P:      Miguel Ojeda Sandonis
> M:      maxextreme@gmail.com
> L:      linux-kernel@vger.kernel.org
> W:      http://auxdisplay.googlepages.com/
> S:      Maintained
> F:      Documentation/auxdisplay/cfag12864b
> F:      drivers/auxdisplay/cfag12864bfb.c
> F:      include/linux/cfag12864b.h
>
> cheers, Joe
>
>

Fine!

Btw, you did me to look at the Documentation to check the correct name
of the "cfag12864b" file, and now, looking at the code, I have
discovered a one-line bug... So the mistake will solve two things at
the same thing! I'm creating the patch now.

Signed-off-by: Miguel Ojeda <maxextreme@gmail.com>

-- 
Miguel Ojeda
http://maxextreme.googlepages.com/index.htm
