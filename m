Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328Ab0CIBDM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 20:03:12 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:27971 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756274Ab0CIBDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 20:03:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=u0uyJNI0SRflEz/o2MoFgbJ8kp5I9IajcKdao9f6wSjYO1sYqHd44/GiXRgpZR28rw
         Sw/qL69zIJJoqLxtFVBYrNDPnqg2api4gnAq5LSz5LhnsyjCDp7LwV2qFLRc/Dhikrhc
         NqM4gSRWM06wNXNom/DOPe3kM7dBc0Vx7LP34=
MIME-Version: 1.0
In-Reply-To: <d8c224af14aa936dcd692c70656559fe9726d997.1266861291.git.ext-andriy.shevchenko@nokia.com>
References: <cover.1266861291.git.ext-andriy.shevchenko@nokia.com>
	 <d8c224af14aa936dcd692c70656559fe9726d997.1266861291.git.ext-andriy.shevchenko@nokia.com>
Date: Tue, 9 Mar 2010 03:03:05 +0200
Message-ID: <5ec8ebd51003081703r76fd2ba7pa850f7568a580181@mail.gmail.com>
Subject: Re: [PATCH 01/11] lib: introduce common method to convert hex digits
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 22, 2010 at 8:09 PM, Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
> hex_to_bin() is a little method which converts hex digit to its actual value.
> There are plenty of places where such functionality is needed.

I found another more than 10 places (roughly there are > 20 of them
already) with such 'copy-paste' logic. Still waiting decision to
include first patch of this series... Any comments, suggestions?

-- 
With Best Regards,
Andy Shevchenko
