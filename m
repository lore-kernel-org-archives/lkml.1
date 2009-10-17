Return-Path: <linux-kernel-owner+w=401wt.eu-S1751028AbZJQFVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751028AbZJQFVj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 01:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750826AbZJQFVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 01:21:38 -0400
Received: from mail-gx0-f216.google.com ([209.85.217.216]:43198 "EHLO
	mail-gx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbZJQFVi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 01:21:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=iCjnGl6LSbVCBlrFo7/Y/fXl6D9yQt4SAiEJSVgrfS5hI/vhoEU+igI+G7RO8lXhi0
         oBoyRknx3QJWdizf4fJTkRhZoUEEY1mkWyh67KcckIx4+HLbpjsAvcj6gt6bsYOZnxMQ
         clKrzJcdw3xgt4eGn/We64lKqricY94+IRuSA=
MIME-Version: 1.0
In-Reply-To: <cb0375e10910161903p59e74f1bx3a711a468bba8dab@mail.gmail.com>
References: <cb0375e10910161903p59e74f1bx3a711a468bba8dab@mail.gmail.com>
Date: Sat, 17 Oct 2009 15:21:42 +1000
Message-ID: <21d7e9970910162221n692d9970o8e8149c46e1ffef4@mail.gmail.com>
Subject: Re: [Intel-gfx] 2.6.32-rc3 regression (I think): i915 framebuffer 
	doesn't work
From: Dave Airlie <airlied@gmail.com>
To: Andrew Lutomirski <luto@mit.edu>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 17, 2009 at 12:03 PM, Andrew Lutomirski <luto@mit.edu> wrote:
> Somewhere between 2.6.32-rc2 and 2.6.32-rc3 (I think -- it might have
> been a bit earlier), the framebuffer stopped working.  I see this
> because Plymouth (F11) boots in test mode not graphical mode.  The
> exact same userspace on 2.6.31 works fine.
>
> (This seems to be getting worse.  Eric Anholt's for-linus worked
> yesterday with text mode plymouth but now just hangs using the same
> image -- I don't have any good explanation for that one.)

yeah its a bug in plymouth but I think I'll revert the kernel at some point.

plymouth thinks fbs with only TrueColor are useful, we now advertise
DirectColor. Not really sure which is more correct, I think fbdev is just
as confused.

Dave.

> This is a Lenovo X200s, which has a GM45.
>
> Thanks,
> Andy
> _______________________________________________
> Intel-gfx mailing list
> Intel-gfx@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/intel-gfx
>
