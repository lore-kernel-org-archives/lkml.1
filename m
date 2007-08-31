Return-Path: <linux-kernel-owner+w=401wt.eu-S1762512AbXHaEsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762512AbXHaEsU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 00:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757158AbXHaEsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 00:48:12 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:8054 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757044AbXHaEsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 00:48:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:references:in-reply-to:subject:date:message-id:mime-version:content-type:content-transfer-encoding:x-mailer:thread-index:content-language;
        b=DOHvhVsMxHktW6xhaAnll36y+f7jbmWoSwWvc22DlOWURJvAzqyHMPWuQsmVhe5pczo6o0NnHzJhKQs+hg1kmPLBxE33waHiy1rd4fwZe+ng0noAsdS+V2oyYDwjgWILzS7Uw6FdJmj6kEEhjSRgIbbJyeudrfi0RYkJQvZO4CQ=
From: "Hua Zhong" <hzhong@gmail.com>
To: "'Linus Torvalds'" <torvalds@linux-foundation.org>,
       "'Trond Myklebust'" <trond.myklebust@fys.uio.no>
Cc: "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
       <akpm@linux-foundation.org>
References: <000701c7eb49$cff701c0$6fe50540$@com>  <1188513433.6626.24.camel@heimdal.trondhjem.org>  <001001c7eb57$afd2d320$0f787960$@com>  <1188516173.6626.46.camel@heimdal.trondhjem.org>  <001501c7eb5d$d295d870$77c18950$@com>  <1188517070.6626.54.camel@heimdal.trondhjem.org>  <001601c7eb5f$b6146980$223d3c80$@com> <1188534682.6626.70.camel@heimdal.trondhjem.org> <alpine.LFD.0.999.0708302134500.25853@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0708302134500.25853@woody.linux-foundation.org>
Subject: RE: recent nfs change causes autofs regression
Date: Thu, 30 Aug 2007 21:47:59 -0700
Message-ID: <002101c7eb8a$1c20e300$5462a900$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcfriMNrHcKCrRHXSr2mJEP2nr+lLQAALi9Q
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 31 Aug 2007, Trond Myklebust wrote:
> >
> > No. Solaris defaults to breaking cache consistency.
> 
> If so, and since that's obviously what people _expect_ to happen, why
> not make that the default, with the "consistent" behaviour being the 
> one that needs an explicit option.
> 
> Just out of curiosity - Hua, is this NFSv2? Especially there, cache
> "consistency" is largely a joke anyway, so defaulting to some annoying
> careful mode is doubly ridiculous.

It's v3 as can be seen from the autofs maps I posted.

These directories are used mostly as read-only and get pulled in via our
build system. We do not actually write to them often, if at all. I don't
think this setup is uncommon, and I am worried that once people start using
the latest kernel their systems will mysteriously break.

> 		Linus

