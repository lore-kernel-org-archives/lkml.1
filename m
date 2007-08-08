Return-Path: <linux-kernel-owner+w=401wt.eu-S935412AbXHHO6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935412AbXHHO6Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 10:58:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754599AbXHHO6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 10:58:17 -0400
Received: from fk-out-0910.google.com ([209.85.128.186]:20968 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754363AbXHHO6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 10:58:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sCMT79ZdBEWyySyh43R9SZp8y2Ua2yFaAfAup4UWotIvgTI8t8qOwF6lv8LUXqrQP0aGmiyijryft7wlOUURG7rJdVXiMvcYWZL4E9aJNATGEes6i1RouN7ehnzZhCTHH2TC2vrwRPCzmhzD7bUdfDBJW615ZmnqliJENCBzsLc=
Message-ID: <5d6222a80708080758t1b937d0ej14c5e60ac23a20c5@mail.gmail.com>
Date: Wed, 8 Aug 2007 11:58:14 -0300
From: "Glauber de Oliveira Costa" <glommer@gmail.com>
To: "Nakajima, Jun" <jun.nakajima@intel.com>
Subject: Re: Introducing paravirt_ops for x86_64
Cc: "Glauber de Oliveira Costa" <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, lguest@ozlabs.org,
       virtualization@lists.linux-foundation.org, chrisw@sous-sol.org,
       anthony@codemonkey.ws, akpm@linux-foundation.org, mingo@elte.hu
In-Reply-To: <97D612E30E1F88419025B06CB4CF1BE10326E129@scsmsx412.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11865467522495-git-send-email-gcosta@redhat.com>
	 <97D612E30E1F88419025B06CB4CF1BE10326E129@scsmsx412.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/8/07, Nakajima, Jun <jun.nakajima@intel.com> wrote:
> Glauber de Oliveira Costa wrote:
> > Hi folks,
> >
> > After some time away from it, and a big rebase as a consequence, here
> is
> > the updated version of paravirt_ops for x86_64, heading to inclusion.
> >
> > Your criticism is of course, very welcome.
> >
> > Have fun
>
> Do you assume that the kernel ougtht to use 2MB pages for its mappings
> (e.g. initilal text/data,  direct mapping of physical memory) under your
> paravirt_ops?  As far as I look at the patches, I don't find one.

I don't think how it could be relevant here. lguest kernel does use
2MB pages, and it goes smootly. For 2MB pages, we will update the page
tables in the very same way, and in the very places we did before.
Just that the operations can now be overwritten.

So, unless I'm very wrong,  it only makes sense to talk about not
supporting large pages in the guest level. But it is not a
paravirt_ops problem.


-- 
Glauber de Oliveira Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."
