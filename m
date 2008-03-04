Return-Path: <linux-kernel-owner+w=401wt.eu-S1763002AbYCDDrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763002AbYCDDrS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 22:47:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757877AbYCDDrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 22:47:06 -0500
Received: from ti-out-0910.google.com ([209.85.142.184]:29736 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756849AbYCDDrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 22:47:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=IL5T+Y28eSrwaC/+mvmgVkouzOCkNuQA7Nm/y1LdyBobOJo8rESeR0RJu+GA/4fqfu7fWhYd6+xAoEVk2vRXDVKmRZ64vWSkYV/jxwyJ/49RVRAEVTe3tdQOQWW3w3gq/r2MoRxaqjy7U+GyTihun0l3dX1LegpmvTzY3+eSvtg=
Message-ID: <37219a840803031947t31c3b302iaa00526f3c0a82c8@mail.gmail.com>
Date: Mon, 3 Mar 2008 22:47:01 -0500
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "Harvey Harrison" <harvey.harrison@gmail.com>
Subject: Re: [v4l-dvb-maintainer] [PATCH] media: replace remaining __FUNCTION__ occurences
Cc: "Mauro Carvalho Chehab" <mchehab@infradead.org>,
       "v4l-dvb-maintainer@linuxtv.org" <v4l-dvb-maintainer@linuxtv.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <1204601394.22933.99.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1204588990.22933.28.camel@brick>
	 <37219a840803031928l79395c78ka64192f4a9f61744@mail.gmail.com>
	 <1204601394.22933.99.camel@brick>
X-Google-Sender-Auth: 1ead83c2615e3497
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 3, 2008 at 10:29 PM, Harvey Harrison
<harvey.harrison@gmail.com> wrote:
>
> On Mon, 2008-03-03 at 22:28 -0500, Michael Krufky wrote:
>  > On Mon, Mar 3, 2008 at 7:03 PM, Harvey Harrison
>  > <harvey.harrison@gmail.com> wrote:
>  > > __FUNCTION__ is gcc-specific, use __func__
>  > >
>  > >  Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
>  > >   162 files changed, 892 insertions(+), 892 deletions(-)
>  >
>  >
>  > If we apply this, can it be broken down into several smaller patches?
>  > I am in the midst of a large overhaul of the tuning subsystem, and if
>  > this all gets applied at once, it will wreck havoc on my pending
>  > changesets.
>  >
>  > Other than that, I'm fine with this change if that's what we're doing
>  > across the rest of the kernel...  Would just be easier to deal with if
>  > it could be further broken down by subdirectory.
>
>  No worries on my part, point me at what tree you'd like it against, and
>  how you'd like it broken up.  Or just give me a shout when it is most
>  convenient to send an update.

OK...  The v4l-dvb development tree is located on linuxtv.org...
Patches should be generated against the master repository, located
here:

http://linuxtv.org/hg/v4l-dvb


As far as breaking up the patch, it would be most convenient for me if
you could break it down such that it is separated by subdirectory, ie:

media/video/cx88/*.[ch]
media/video/saa7134/*.[ch]
media/video/*.[ch]
media/dvb/flexcop/*.[ch]
media/dvb/frontends/*.[ch]

etc... you get the idea --

There's no need to blast all of those patches onto the mailing lists
-- if you put them all into a tar.gz and email them to me privately,
then I'll push them into my mercurial tree and ask Mauro to merge them
into the master devel branch...  They'll most likely end up going to
2.6.26

Having them broken down by directory will allow me to merge them in
without conflicting with other pending changesets.

Regards,

Mike
