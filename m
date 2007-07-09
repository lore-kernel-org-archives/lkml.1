Return-Path: <linux-kernel-owner+w=401wt.eu-S1759542AbXGIUrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759542AbXGIUrc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 16:47:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755361AbXGIUrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 16:47:25 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:1969 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755299AbXGIUrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 16:47:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qVlvKXcVLYX56U88Su2wjr5bge3uDhaLMLVjl5MCi+Xx+nvV1uasSocatw/0F5Ok/nG5lo/n9Y5gsZIRJOsgIu6LfWUIwAN8hvryYksnSeor1RxK9FFQKLx/wHeQ/SuQaiw0R+iE4/pyaVIgbRRrlObqFTv+FdWjqISjKdXFCXo=
Message-ID: <a781481a0707091347u2ab1380dkc08c1077de99ca82@mail.gmail.com>
Date: Tue, 10 Jul 2007 02:17:23 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: can entire drivers/acorn subdirectory be removed?
Cc: "Dr. David Alan Gilbert" <linux@treblig.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0707091637090.10650@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0707060632330.12604@localhost.localdomain>
	 <20070706183244.GB25207@gallifrey>
	 <Pine.LNX.4.64.0707091637090.10650@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/10/07, Robert P. J. Day <rpjday@mindspring.com> wrote:
> On Fri, 6 Jul 2007, Dr. David Alan Gilbert wrote:
>
> > * Robert P. J. Day (rpjday@mindspring.com) wrote:
> >
> > >   and if that happens, then the config variables defined in
> > > drivers/acorn/block/Kconfig:
> > >
> > >   config BLK_DEV_FD1772
> > >   config BLK_DEV_MFM
> > >   config BLK_DEV_MFM_AUTODETECT
> > >
> > > would also vanish, which suggests that any references to *them* could
> > > also be deleted:
> >
> > Ah those are blasts from the past; I've got to wonder how many MFM
> > drives that still work are out there.
>
> the question remains -- is there any value to keeping the acorn stuff
> given that the Kconfig variables to select that code aren't defined
> anywhere?

Would be best to just send out a patch getting rid of all that cruft.
If anybody (maintainer or otherwise) disagrees, we'll know then.

Satyam
