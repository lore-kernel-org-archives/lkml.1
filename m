Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393Ab0CDXDH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 18:03:07 -0500
Received: from mail-iw0-f175.google.com ([209.85.223.175]:46414 "EHLO
	mail-iw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254Ab0CDXDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 18:03:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=SL6oGefhcfMI8eoNXFhWDsysBkE67y2bUwg0w5RmInzqfUM0NZ//SpEqpEBrM7Bk56
         SZ6ZRJsP7CHm2U4FSiBd2Rukgte6CVc8DgacvO+HqxiYaJJgU9LjCjp23pk0p6XzjyFb
         nPXDioRqXvdMSfLNFgsXny6Ax3ajvAi6aPYkA=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1003041449380.3751@localhost.localdomain>
References: <alpine.DEB.2.00.1003022345100.4099@skynet.skynet.ie>
	 <alpine.LFD.2.00.1003041051470.3751@localhost.localdomain>
	 <20100304190450.GA23807@srcf.ucam.org>
	 <alpine.LFD.2.00.1003041110070.3751@localhost.localdomain>
	 <20100304192524.GA24253@srcf.ucam.org>
	 <alpine.LFD.2.00.1003041131490.3751@localhost.localdomain>
	 <20100304195302.GA24856@srcf.ucam.org>
	 <alpine.LFD.2.00.1003041202240.3751@localhost.localdomain>
	 <6a89f9d51003041257j39fde3b6y8bd3336d77f7cf7a@mail.gmail.com>
	 <alpine.LFD.2.00.1003041449380.3751@localhost.localdomain>
Date: Fri, 5 Mar 2010 09:03:03 +1000
Message-ID: <21d7e9971003041503p726ecbebi4b0b97854c5824de@mail.gmail.com>
Subject: Re: [git pull] drm request 3
From: Dave Airlie <airlied@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stephane Marchesin <stephane.marchesin@gmail.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Dave Airlie <airlied@linux.ie>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 5, 2010 at 8:54 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Thu, 4 Mar 2010, Stephane Marchesin wrote:
>>
>> In short, the "don't break user space interfaces" principle is making
>> user space code quality worse for everyone. And it makes our lives as
>> graphics developers pretty miserable actually
>
> And _my_ point is that if you did a half-way decent job on versioning, you
> wouldn't be in the crappy situation you are now.
>
> For chissake, the DRM versioning model is a total disaster. The reason you
> can never ever break user space interfaces is exactly because when you
> break them, X stops working.

Stop aligning DRM versioning with nouveau versioning. This isn't a generic
problem with DRM, we've supported versioning interfaces for years and
have broken them maybe once.

> What I suggested is to _keep_ a working model across different versions,
> so that you can get out of the rat-hole you are in now (and the rat-hole
> you put your users into, and the distributions).
>
> It's simply _not_ acceptable to tie the X server and the kernel version so
> tightly together as the crazy DRM model does right now. It's not all that
> different from us requiring people to install a new glibc every once in a
> while, just because we added a new filesystem. Everybody understands that
> that would be totally insane.
>
> Why does the X community not understand simple library versioning?

Its nouveau project not X not DRM, stop generalising the situation.

Dave.
