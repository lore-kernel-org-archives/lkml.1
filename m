Return-Path: <linux-kernel-owner+w=401wt.eu-S1764221AbYD0T6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764221AbYD0T6r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 15:58:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755581AbYD0T6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 15:58:39 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:37789 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899AbYD0T6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 15:58:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oCHWD2vva3y/BpOXZqKQBMd/k4Ts27RPrbPNHrSrUAzpxgWegXtFXYB07+j8bPFYdwIRx/ddnG6D2XhTjsFNRWQIJPz9GFgSkPZ/ss1M7oK9mhSX2uhftbbv0CK677OLjVyGyU9ClE9ODjrwfqWBkB/EBrfiSRimjTPevQTKkTg=
Message-ID: <9a8748490804271258p21d47ce8g8d720107f767faac@mail.gmail.com>
Date: Sun, 27 Apr 2008 21:58:20 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Willy Tarreau" <w@1wt.eu>
Subject: Re: A system for rebootless kernel security updates
Cc: "Pavel Machek" <pavel@ucw.cz>, "Tomasz Chmielewski" <mangoo@wpkg.org>,
       LKML <linux-kernel@vger.kernel.org>, jbarnold@mit.edu,
       francois.cami@free.fr, "Andi Kleen" <andi@firstfloor.org>,
       mail@earthworm.de
In-Reply-To: <20080427174947.GI8474@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <481098A4.50107@wpkg.org> <20080427101659.GD3891@ucw.cz>
	 <20080427174947.GI8474@1wt.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/4/27 Willy Tarreau <w@1wt.eu>:
> On Sun, Apr 27, 2008 at 12:17:00PM +0200, Pavel Machek wrote:
>  > On Thu 2008-04-24 16:26:44, Tomasz Chmielewski wrote:
>  > > Jeff Arnold wrote:
>  > >
>  > > >I've put together an automatic system for applying
>  > > >kernel security patches to the Linux kernel without
>  > > >rebooting it, and I wanted to share this system with
>  > > >the community in case others find it useful or
>  > > >interesting.
>  > >
>  > > Hmm, the idea seem to be patented by Microsoft, i.e.
>  > > this patent from December 2002:
>  > >
>  > > http://www.google.com/patents?id=cVyWAAAAEBAJ&dq=hotpatching
>  > >
>  > > (and other patents by Microsoft if you search for
>  > > "hotpatching").
>  >
>  > ...so US will not be able to fix security holes without reboot, good.
>  > Perhaps they fix their stupid laws after next worm outbreak...
>
>  Sounds like a bullshit patent. I remember having loaded a lot of NLM
>  patches under netware 4.0 in 96-97 without ever rebooting. I think
>  that the patches only redefined the faulty symbol(s) they wanted to
>  patch. That was pretty convenient because when in doubt, you could
>  simply unload the modules and get back to previous situation.
>

And then there's 'alternatives' that patch running code, there's kexec
and I guess you could even say that various root kits that patch the
running kernel get prior art on that patent ;)

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please http://www.expita.com/nomime.html
