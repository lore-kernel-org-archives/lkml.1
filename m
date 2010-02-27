Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030428Ab0B0SIw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 13:08:52 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:42281 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030293Ab0B0SIv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 13:08:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fpn7Y4LweXrd7E4qfrU8HWBITVyvJ38UWchuy0nX2PMRtO+T7yUUbvOlXYhq2+sgz4
         /KQqzSIWJFH+3NEGlre2atoifvg7RcnY917T0x5ZAGUPPe5/GoTunu+QLcOeUgGz6rbm
         WtTcYzxXjpS5ks60Oy06Mi1GsBdgQTUvF/KyA=
MIME-Version: 1.0
In-Reply-To: <20100227084906.6b05fa5e@jbarnes-piketon>
References: <d9def9db1002261942k27b64dd4g670dd29969c93cbf@mail.gmail.com>
	 <d9def9db1002262034p55cd569n6c423741c276798d@mail.gmail.com>
	 <20100227051737.GA14976@kroah.com> <20100227052648.GA31418@kroah.com>
	 <d9def9db1002262138q63c410b7ga7c04f35b6f154ff@mail.gmail.com>
	 <20100227054808.GA32225@kroah.com>
	 <d9def9db1002270300g7e256fc6n6fbb4fd08d951fb8@mail.gmail.com>
	 <84144f021002270415r7c61236elb0208cd5d0821ab5@mail.gmail.com>
	 <84144f021002270417j4d690ad2qf5db26b2b6dad232@mail.gmail.com>
	 <20100227084906.6b05fa5e@jbarnes-piketon>
Date: Sat, 27 Feb 2010 19:08:49 +0100
Message-ID: <d9def9db1002271008j197d9a57md500c1ba44fc81c6@mail.gmail.com>
Subject: Re: 2.6.33 bugs (USBFS, Intel graphic)
From: Markus Rechberger <mrechberger@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Greg KH <greg@kroah.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-usb@vger.kernel.org, werner@guyane.dyn-o-saur.com,
       Marcus Meissner <meissner@suse.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 27, 2010 at 5:49 PM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> On Sat, 27 Feb 2010 14:17:14 +0200
> Pekka Enberg <penberg@cs.helsinki.fi> wrote:
>
>> On Sat, Feb 27, 2010 at 2:15 PM, Pekka Enberg
>> <penberg@cs.helsinki.fi> wrote:
>> > On Sat, Feb 27, 2010 at 1:00 PM, Markus Rechberger
>> > <mrechberger@gmail.com> wrote:
>> >>> Linus, I know you didn't want to do a kzalloc, but it looks like
>> >>> this is the easiest/simplest thing to do, unless you can think of
>> >>> something else?
>> >>
>> >> do you have any idea what to cherrypick in order to get rid of that
>> >> flickering with the intel GM45?
>> >> The flickering itself occures randomly, it was not there with the
>> >> original Ubuntu kernel (2.6.31 with alot patches)
>> >> This is pretty much a standard graphicchip nowadays....
>> >
>> > Yeah, same here. I tried to bisect the damn thing but didn't find
>> > any single commit. I think the problem was introduced in in the DRM
>> > merge between 2.6.31 and 2.6.32-rc1. Some people suggested
>> > privately that it might be related to frame buffer compression.
>> > Unfortunately I wasn't able to revert that particular patch.
>>
>> Btw, after I reinstalled Ubuntu 9.10 from scratch for unrelated
>> reasons, I haven't seen the flicker effect. Dunno if that's just a
>> coincidence or if userspace has something to do with the bug.
>
> Some people reported ACPI related flicker due to lid detection taking a
> long time and X periodically probing for it.  Maybe that's what you
> were seeing?
>

little bit offtopic there's another bug with the intel driver. Seems
like there's a memory pool which collects all the memory during the
runtime and especially makes the memory usage go up:
http://bugs.freedesktop.org/show_bug.cgi?id=26708
Maybe someone at Intel can have a closer look at that one...

another obvious bug seems to be offloading mpeg2 video to the GPU it
takes more CPU than decoding mpeg2 with software. Offloading is quite
important nowadays due HDTV. The only one which has working linux
support is NVidia with their closed source drivers.

Markus
