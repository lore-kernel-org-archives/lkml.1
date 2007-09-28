Return-Path: <linux-kernel-owner+w=401wt.eu-S1759894AbXI1OOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759894AbXI1OOo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 10:14:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752204AbXI1OOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 10:14:36 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:33997 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755317AbXI1OOf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 10:14:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qjicXENooXmUHI0lc+ql7h9Pp29DCj18C201mpzWS7dQzpyXT5Fkr2qZlccGGzpCFc6DE9gKYif//0yset+yf/DLMO3l/W+cL0kstWf2VcvvGLySxqJRQRas43FU04PXqfc6C95r2NJFdlqzsMjOAXB1h0bF+Fid0nKQWMbigXs=
Message-ID: <cfd9edbf0709280714u7a03ec16pfe3cb7328dbab7ad@mail.gmail.com>
Date: Fri, 28 Sep 2007 16:14:32 +0200
From: "=?ISO-8859-1?Q?Daniel_Sp=E5ng?=" <daniel.spang@gmail.com>
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Subject: Re: Out of memory management in embedded systems
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.61.0709281000300.9062@chaos.analogic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <cfd9edbf0709280555n51afa8aft5040331ae9c227fd@mail.gmail.com>
	 <Pine.LNX.4.61.0709280857520.8940@chaos.analogic.com>
	 <cfd9edbf0709280630x7396e49fi523e1d58aab9458a@mail.gmail.com>
	 <Pine.LNX.4.61.0709281000300.9062@chaos.analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/28/07, linux-os (Dick Johnson) <linux-os@analogic.com> wrote:
>
> On Fri, 28 Sep 2007, [iso-8859-1] Daniel Spång wrote:
>
> > On 9/28/07, linux-os (Dick Johnson) <linux-os@analogic.com> wrote:
> >>
> >> But an embedded system contains all the software that will
> >> ever be executed on that system! If it is properly designed,
> >> it can never run out of memory because everything it will
> >> ever do is known at design time.
> >
> > Not if its input is not known beforehand. Take a browser in a mobile
> > phone as an example, it does not know at design time how big the web
> > pages are. On the other hand we want to use as much memory as
> > possible, for cache etc., a method that involves the kernel would
> > simplify this and avoids setting manual limits.
> >
> > Daniel
> >
>
> Any networked appliance can (will) throw data away if there are
> no resources available.
>
> The length of a web-page is not relevent, nor is the length
> of any external data. Your example will buffer whatever it
> can and not read anything more from the external source until
> it has resources available unless it is broken.

And how do you determine when no resources are availabe? We are using
overcommit here so malloc() will always return non null.
