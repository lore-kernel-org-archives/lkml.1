Return-Path: <linux-kernel-owner+w=401wt.eu-S1752674AbZK1RGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674AbZK1RGo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 12:06:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751983AbZK1RGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 12:06:43 -0500
Received: from mail-qy0-f194.google.com ([209.85.221.194]:46299 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785AbZK1RGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 12:06:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=E4gB4FAT2s5B9cBc3TecaAU9M8Sa5UnXabxrIOebLz7xsf/Lae3SLZSKgQJ/VTNnMn
         USrrctiCfFic8+AE8O3NDtoEkcpjJtpbbtfC46xO4f5hGl5XTU8NMWKqg7nwf3agEEq5
         YeQqbsr3mDws3YJFEgbz3DJWGz0yee32qY8KU=
MIME-Version: 1.0
In-Reply-To: <BDkdITRHqgB@lirc>
References: <m3r5riy7py.fsf@intrepid.localdomain> <BDkdITRHqgB@lirc>
Date: Sat, 28 Nov 2009 12:06:48 -0500
Message-ID: <9e4733910911280906if1191a1jd3d055e8b781e45c@mail.gmail.com>
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR 
	system?
From: Jon Smirl <jonsmirl@gmail.com>
To: Christoph Bartelmus <lirc@bartelmus.de>
Cc: khc@pm.waw.pl, awalls@radix.net, dmitry.torokhov@gmail.com, j@jannau.net,
       jarod@redhat.com, jarod@wilsonet.com, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
       maximlevitsky@gmail.com, mchehab@redhat.com, stefanr@s5r6.in-berlin.de,
       superm1@ubuntu.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 28, 2009 at 11:47 AM, Christoph Bartelmus <lirc@bartelmus.de> wrote:
> @Maxim: I think Mauro is right. We need to find an approach that makes
> everybody happy. We should take the time now to discuss all the
> possibilities and choose the best solution. LIRC has lived so long outside
> the kernel, that we can wait another couple of weeks/months until we
> agreed on something which will be a stable API hopefully for many years to
> come.

Please do this. That's why I started this thread off with goals for
the implementation. After we settle on a set of goals we can move on
to how to implement those goals.  The end result is almost certainly
going to combine aspects from all of the various proposals and the
LIRC code base is likely to be the largest contributor.

There are two very basic things that we need to reach consensus on first.

1) Unification with mouse/keyboard in evdev - put IR on equal footing.
2) Specific tools (xmodmap, setkeycodes, etc or the LIRC ones) or
generic tools (ls, mkdir, echo) for configuration

Once consensus is reached in those two areas everything else should be
much easier.

-- 
Jon Smirl
jonsmirl@gmail.com
