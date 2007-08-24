Return-Path: <linux-kernel-owner+w=401wt.eu-S1763305AbXHXMoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763305AbXHXMoA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 08:44:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756825AbXHXMnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 08:43:51 -0400
Received: from wx-out-0506.google.com ([66.249.82.231]:64370 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759236AbXHXMnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 08:43:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=D0i5ASrP0AUp99nfestkmQpIerq5Kb2LA/ZE8Sk887mIo+N/hvg4cAkEbrimpN52X23ABsu095MdiXG9zeuBvnEDcExuUdSJjXv1248lsHxgMJp8FlYWeay5wXfn4YQxF24SY66X2m1AKowHItrNVqSMsnuJ8CPHOpWM0U79eT8=
Message-ID: <ed10ee420708240543r27db83e9l25300c2799c7c2cd@mail.gmail.com>
Date: Fri, 24 Aug 2007 05:43:47 -0700
From: "SL Baur" <steve@xemacs.org>
To: "Andy Whitcroft" <apw@shadowen.org>
Subject: Re: false positive in checkpatch.pl (complex macro values)
Cc: "Mike Frysinger" <vapier.adi@gmail.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Michael Hennerich" <michael.hennerich@analog.com>
In-Reply-To: <46CEC3D4.40805@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8bd0f97a0708240051w7fc00b01w8dc1b39fe606bfe4@mail.gmail.com>
	 <46CEC3D4.40805@shadowen.org>
X-Google-Sender-Auth: fd2dd6eeb2442006
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/24/07, Andy Whitcroft <apw@shadowen.org> wrote:
> Mike Frysinger wrote:
> > in some code that does like:
> > #define foo { a, b, c, \
> >     d, e, f, g }
> > ...
> > int boo[] = foo;
> > ...
> >
> > checkpatch.pl throws a fit:
> > ERROR: Macros with complex values should be enclosed in parenthesis
> > #10: FILE: ...
> > +#define foo {a, b, c, d}
> >
> > perhaps the check should also allow {...} ?  or ignore lists like this ...
> > -mike
>
> Ok, we can add that to the check.  Next update will allow that.
>
> Thanks for the report.

I sent a reply accidentally only to Mike and not the list.  I think the
error message is wrong.  That is really ugly code.  Linux Kernel code
believes in C not preprocessor tricks, so why would you need this?

Who uses code like this, by the way?

-sb
