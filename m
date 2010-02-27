Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967801Ab0B0MRR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 07:17:17 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:59084 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966055Ab0B0MRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 07:17:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=EXYL3tJ/6lThIz9P5IbCg1il4tnU3RnCA9eE7PdxedKuqXJJINygvlIYU5gju3u6ky
         6TZUKe1LluQs8brMdGTklauYKWXeD4GS84j/f7xf5xL/xoGOP9fDZVect+Y91hy/o2ku
         E9Tr4YU1Kera4YgSQWc+IY+zp4SOOzUDdx8jw=
MIME-Version: 1.0
In-Reply-To: <84144f021002270415r7c61236elb0208cd5d0821ab5@mail.gmail.com>
References: <d9def9db1002261942k27b64dd4g670dd29969c93cbf@mail.gmail.com>
	 <20100227041815.GA12956@kroah.com>
	 <alpine.LFD.2.00.1002262022090.4513@localhost.localdomain>
	 <d9def9db1002262034p55cd569n6c423741c276798d@mail.gmail.com>
	 <20100227051737.GA14976@kroah.com> <20100227052648.GA31418@kroah.com>
	 <d9def9db1002262138q63c410b7ga7c04f35b6f154ff@mail.gmail.com>
	 <20100227054808.GA32225@kroah.com>
	 <d9def9db1002270300g7e256fc6n6fbb4fd08d951fb8@mail.gmail.com>
	 <84144f021002270415r7c61236elb0208cd5d0821ab5@mail.gmail.com>
Date: Sat, 27 Feb 2010 14:17:14 +0200
X-Google-Sender-Auth: 404e03d95bdd0e6a
Message-ID: <84144f021002270417j4d690ad2qf5db26b2b6dad232@mail.gmail.com>
Subject: Re: 2.6.33 bugs (USBFS, Intel graphic)
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Markus Rechberger <mrechberger@gmail.com>
Cc: Greg KH <greg@kroah.com>, Linus Torvalds <torvalds@linux-foundation.org>,
       linux-usb@vger.kernel.org, werner@guyane.dyn-o-saur.com,
       Marcus Meissner <meissner@suse.de>, linux-kernel@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 27, 2010 at 2:15 PM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> On Sat, Feb 27, 2010 at 1:00 PM, Markus Rechberger
> <mrechberger@gmail.com> wrote:
>>> Linus, I know you didn't want to do a kzalloc, but it looks like this is
>>> the easiest/simplest thing to do, unless you can think of something
>>> else?
>>
>> do you have any idea what to cherrypick in order to get rid of that
>> flickering with the intel GM45?
>> The flickering itself occures randomly, it was not there with the
>> original Ubuntu kernel (2.6.31 with alot patches)
>> This is pretty much a standard graphicchip nowadays....
>
> Yeah, same here. I tried to bisect the damn thing but didn't find any
> single commit. I think the problem was introduced in in the DRM merge
> between 2.6.31 and 2.6.32-rc1. Some people suggested privately that it
> might be related to frame buffer compression. Unfortunately I wasn't
> able to revert that particular patch.

Btw, after I reinstalled Ubuntu 9.10 from scratch for unrelated
reasons, I haven't seen the flicker effect. Dunno if that's just a
coincidence or if userspace has something to do with the bug.
