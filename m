Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476Ab0BVVSS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 16:18:18 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:52893 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753962Ab0BVVSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 16:18:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=K0rUoGnyNwRwScUF/hTBiab/oOmrnN51LK7IWj1CxYbx3Om88emMm8AcTUnuTX7Pv6
         uVS0a5KO6YQ2jXgin6eC0tDGjrctSZ0aow+kaD7BgWxQPhHabSygsgB21+kLpeu/7wXc
         LAEv+urTmOa7qT06fRA40pxs51plM1c3R9ZtQ=
MIME-Version: 1.0
In-Reply-To: <7e0fb38c1002221221xf8a2fb8ob3eb0098e8e75faf@mail.gmail.com>
References: <1266519351-3218-1-git-send-email-andy.shevchenko@gmail.com>
	 <1266519351-3218-2-git-send-email-andy.shevchenko@gmail.com>
	 <1266519351-3218-3-git-send-email-andy.shevchenko@gmail.com>
	 <7e0fb38c1002221221xf8a2fb8ob3eb0098e8e75faf@mail.gmail.com>
Date: Mon, 22 Feb 2010 23:18:15 +0200
Message-ID: <5ec8ebd51002221318o46be0271y6d2228bbc5144a67@mail.gmail.com>
Subject: Re: [PATCH 02/12] audit: use kernel's method to get byte in hex form
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Eric Paris <eparis@parisplace.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andy Shevchenko <ext-andriy.shevchenko@nokia.com>, aviro@redhat.com,
       Eric Paris <eparis@redhat.com>, Steve Grubb <sgrubb@redhat.com>,
       dwalsh@redhat.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 22, 2010 at 10:21 PM, Eric Paris <eparis@parisplace.org> wrote:
> It changes the case from ABCDEF to abcdef but there are a number of
> userspace tools which might not be able to handle it,
Yeah, that's true.

> have you tested any or all of these?
Not yet. Anyway, thanks for point. I know how to modify patch to
return behaviour back (there is macro toupper() which we have to use).

I'll resend fixed patch if no objections.

-- 
With Best Regards,
Andy Shevchenko
