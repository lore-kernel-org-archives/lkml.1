Return-Path: <linux-kernel-owner+w=401wt.eu-S1752332AbXKVIl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332AbXKVIl4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 03:41:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751353AbXKVIlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 03:41:45 -0500
Received: from wx-out-0506.google.com ([66.249.82.236]:50296 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841AbXKVIlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 03:41:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YWPyYVk0drFUUCyVKGVDawzWfOx+/A3KMA7lihOVdJm8VgwR3dRl3fqvtlLhteKhpl1RAt1ad0LXEebpqIU8KrOhqvzt9OOV1X/nFKTA1i9BXdMxreGIradnjY0tMZ2M3l0mF6DrVTzrujLfulcugOrKzmU80473b9UNkZmV9sk=
Message-ID: <a8e1da0711220041v3d3c27d2pf7f326185666420d@mail.gmail.com>
Date: Thu, 22 Nov 2007 16:41:43 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Rusty Russell" <rusty@rustcorp.com.au>
Subject: Re: [PATCH RFC] [1/9] Core module symbol namespaces code and intro.
Cc: "Andi Kleen" <ak@suse.de>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, sam@ravnborg.org
In-Reply-To: <200711221456.22297.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071122343.446909000@suse.de>
	 <200711221456.22297.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 22, 2007 11:56 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> On Thursday 22 November 2007 13:43:06 Andi Kleen wrote:
> > There seems to be rough consensus that the kernel currently has too many
> > exported symbols. A lot of these exports are generally usable utility
> > functions or important driver interfaces; but another large part are
> > functions intended by only one or two very specific modules for a very
> > specific purpose.
>
> Hi Andi,
>
>     This is an interesting idea, thanks for the code!  My only question is
> whether we can get most of this benefit by dropping the indirection of
> namespaces and have something like "EXPORT_SYMBOL_TO(sym, modname)"?

Andy, I like your idea.  IMHO, as Rusty said a simple EXPORT_SYMBOL_TO
is better.

And I wonder if it is possible to export to something like  the struct
device_driver? If it's possible then it will not limited to modules.

> doesn't work so well for exporting to a group of modules, but that seems
> a reasonable line to draw anyway.
>
> Cheers,
> Rusty.
> PS.  Probably better to use the standard warnx and errx in modpost, too.
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
