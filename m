Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722Ab0CEUeh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 15:34:37 -0500
Received: from mail-iw0-f189.google.com ([209.85.223.189]:37200 "EHLO
	mail-iw0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730Ab0CEUeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 15:34:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=omGfrDBXvQ81iny1xGrVsOEWduVnkP2Ifs8v1tugnfxEzyY9T0Z5HMMiUCil4wEApn
         yY1IVeAVnkDTgPp2ynfIU3z6TYxG4tiKUtOc6DJ8dsC5tCyHQpdr27V4cPax/M60Gfez
         FJ4YZ0rrmZ8q+K7Z9akPjXKdRhOqw2XUUUdjo=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1003041635280.3751@localhost.localdomain>
References: <alpine.DEB.2.00.1003022345100.4099@skynet.skynet.ie>
	 <alpine.LFD.2.00.1003041047400.3751@localhost.localdomain>
	 <20100304105624.70fe845e@jbarnes-piketon>
	 <alpine.LFD.2.00.1003041101390.3751@localhost.localdomain>
	 <21d7e9971003041125x1aee3b3ew1e407ca6695e10fc@mail.gmail.com>
	 <alpine.LFD.2.00.1003041142250.3751@localhost.localdomain>
	 <21d7e9971003041406n53d9cae0h53374abf3dca494e@mail.gmail.com>
	 <alpine.LFD.2.00.1003041554490.3751@localhost.localdomain>
	 <1267748927.3496.6.camel@nisroch>
	 <alpine.LFD.2.00.1003041635280.3751@localhost.localdomain>
Date: Fri, 5 Mar 2010 22:34:35 +0200
Message-ID: <94a0d4531003051234u48f66c9eo1a26746892eb102a@mail.gmail.com>
Subject: Re: [git pull] drm request 3
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ben Skeggs <skeggsb@gmail.com>, Dave Airlie <airlied@gmail.com>,
       Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>, dri-devel@lists.sf.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 5, 2010 at 2:41 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, 5 Mar 2010, Ben Skeggs wrote:
>> The F13 packages *will* work, so long as you're not bisecting back and
>> forth.
>
> How do I install just the F13 libdrm thing, without changing everything
> else? I'm willing to try. We can make it part of the 2.6.34 release notes.
>
> And if we end up having people bisecting back and forth, I will hate that
> f*cking nouveau driver even more.

I believe Dave has already explained this to you, but nobody has
mentioned it here.

What you are supposed to do is install the new nouveau driver, which
requires a new libdrm. So, just compile both libdrm, and nouveau, to a
sandbox, say /opt/new-nouveau, and then in /etc/X11/xorg.conf:

Section "Files"
        ModulePath "/opt/new-nouveau/lib/xorg/modules"
        ModulePath "/usr/lib/xorg/modules"
EndSection

That should do it. No frankensteinian F13 packaging stuff, and no mess
with the system's /usr/lib/.

Cheers.

-- 
Felipe Contreras
