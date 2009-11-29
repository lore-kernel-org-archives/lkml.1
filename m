Return-Path: <linux-kernel-owner+w=401wt.eu-S1753135AbZK2TQK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135AbZK2TQK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 14:16:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753070AbZK2TQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 14:16:09 -0500
Received: from mail-qy0-f194.google.com ([209.85.221.194]:53425 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986AbZK2TQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 14:16:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=NFckhAT2QgfFSzZkPhbeH9i7R1A/tDZ48oDhcRURLFby8io1rFeAOopNBGnk9tay7V
         WthmNmrbfdGSTPwDI+vEt7TiuR5kESl4YAg1QZng3JKIEfmcwAyk4LntzHM7hbc7/ud8
         0g0hDpSBZZMM7xyYmvQpRJP1rO+etl9wSDiP0=
MIME-Version: 1.0
In-Reply-To: <20091129190435.6500ac84@lxorguk.ukuu.org.uk>
References: <m3r5riy7py.fsf@intrepid.localdomain>
	 <m3aay6y2m1.fsf@intrepid.localdomain>
	 <9e4733910911280937k37551b38g90f4a60b73665853@mail.gmail.com>
	 <1259469121.3125.28.camel@palomino.walls.org>
	 <20091129124011.4d8a6080@lxorguk.ukuu.org.uk>
	 <1259515703.3284.11.camel@maxim-laptop>
	 <2c0942db0911290949p89ae64bjc3c7501c2de6930c@mail.gmail.com>
	 <20091129181316.7850f33c@lxorguk.ukuu.org.uk>
	 <2c0942db0911291052n6e9dd116x943ee636bcf548b9@mail.gmail.com>
	 <20091129190435.6500ac84@lxorguk.ukuu.org.uk>
Date: Sun, 29 Nov 2009 14:16:11 -0500
Message-ID: <9e4733910911291116r66dda6dap591d1b0f322f9663@mail.gmail.com>
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR 
	system?
From: Jon Smirl <jonsmirl@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ray Lee <ray-lk@madrabbit.org>, Maxim Levitsky <maximlevitsky@gmail.com>,
       Andy Walls <awalls@radix.net>, Krzysztof Halasa <khc@pm.waw.pl>,
       Christoph Bartelmus <lirc@bartelmus.de>, dmitry.torokhov@gmail.com,
       j@jannau.net, jarod@redhat.com, jarod@wilsonet.com,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-media@vger.kernel.org, mchehab@redhat.com,
       stefanr@s5r6.in-berlin.de, superm1@ubuntu.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 29, 2009 at 2:04 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> Jon is asking for an architecture discussion, y'know, with use cases.
>> Maxim seems to be saying it's obvious that what we have today works
>> fine. Except it doesn't appear that we have a consensus that
>> everything is fine, nor an obvious winner for how to reduce the
>> complexity here and keep the kernel in a happy, maintainable state for
>> the long haul.
>
> The important point is that this is not an A or B discussion. There are
> lots of ways to tackle it that are neither. If you look at things like
> complex video format handling it is done in user space but with an
> infrastructure to handle it.
>
> I don't believe putting it in the kernel is the alternative to the
> current setup. Cleaning up the way what we have today is presented to
> applications is perfectly possible without a whole new pile of kernel
> crap, because evdev was designed sensibly in the first place to allow
> userspace added events.

So we're just back to the status quo of last year which is to do
nothing except some minor clean up.

We'll be back here again next year repeating this until IR gets
redesigned into something fairly invisible like keyboard and mouse
drivers.

-- 
Jon Smirl
jonsmirl@gmail.com
