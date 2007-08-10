Return-Path: <linux-kernel-owner+w=401wt.eu-S940933AbXHJQfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940933AbXHJQfl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 12:35:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765418AbXHJQfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 12:35:33 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:18211 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765174AbXHJQfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 12:35:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Rw4dalexad+Oa2tEPK1A/pWJuTrtd4D5b78yB01qmAF8VL5PkV1rWtAjs31XizfN8lC/Zchktr6vF+i2B72q6lwr8yNrkmWS7wOYHqHPwgxqP8pvOM5vDzVpIUOdYBPobIIW64pINx1sLXKCgmD+dtfqZzhMZTX3uJSUDYTaRTs=
Message-ID: <13426df10708100935s64bffb1i22238704651844fb@mail.gmail.com>
Date: Fri, 10 Aug 2007 09:35:30 -0700
From: "ron minnich" <rminnich@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: [PATCH] ld.so on FC7 is mmap'ing shared libraries right in over guest memory.
Cc: "Rusty Russell" <rusty@rustcorp.com.au>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>, lguest <lguest@ozlabs.org>,
       "lkml - Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <1186670916.4521.1.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1186657645.17752.60.camel@localhost.localdomain>
	 <1186670916.4521.1.camel@laptopd505.fenrus.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/9/07, Arjan van de Ven <arjan@infradead.org> wrote:
> On Thu, 2007-08-09 at 21:07 +1000, Rusty Russell wrote:
> > From: Ronald G. Minnich <rminnich@gmail.com>
> >
> > [ FC7 maps shared libraries very low, where the launcher maps guest's
> > physical memory.  Quick fix is to link Launcher static, real fix is for
> > 2.6.24. ]
> >
> > -static is a simple fix. I expect this problem will be more common than we
> > like, as different distro's make different "improvements" to ld.so
>
>
> this description is incorrect; it's not an ld.so change that causes the
> low mapping.
>
> It's a command line option to the prelink program (which is in most
> distributions) that makes it use the entire address space, not just the
> higher bits....

oops. That'll teach me.

Thanks for the correction :-)

ron
