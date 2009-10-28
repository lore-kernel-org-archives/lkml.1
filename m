Return-Path: <linux-kernel-owner+w=401wt.eu-S932491AbZJ1DBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932491AbZJ1DBd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 23:01:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932465AbZJ1DBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 23:01:33 -0400
Received: from mail-gx0-f216.google.com ([209.85.217.216]:54574 "EHLO
	mail-gx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932397AbZJ1DBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 23:01:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=btFsV//p2zR7Z87DHibdBEO3TKiDK02oZiJhS+8bClcfhcWzvYROubgY4KmYCmz3r6
         P/B9NcLT+rL0o5aXnaAyjWR342Ekum6elcJzavJcn6pYIAZR83Hz3FNYqzXe4yHZKvk4
         SMKCqlTjCLFYkg5wtygBbq4sjA/yZsosMlGUU=
MIME-Version: 1.0
In-Reply-To: <20091027.192553.83746115.davem@davemloft.net>
References: <21d7e9970910271822p3751b2fdnd78e1bc3326b9b0b@mail.gmail.com>
	 <20091027.192553.83746115.davem@davemloft.net>
Date: Wed, 28 Oct 2009 13:01:36 +1000
Message-ID: <21d7e9970910272001y77682572od540572bdac4eb54@mail.gmail.com>
Subject: Re: is avoiding compat ioctls possible?
From: Dave Airlie <airlied@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net,
       arnd@arndb.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 28, 2009 at 12:25 PM, David Miller <davem@davemloft.net> wrote:
> From: Dave Airlie <airlied@gmail.com>
> Date: Wed, 28 Oct 2009 11:22:18 +1000
>
>> Is there really no way to avoid compat ioctls? was I delusional in
>> thinking there was?
>
> If you use pointers in your interfaces in any way, no.
>
> And for this drm_radeon_info thing the pointer is "pointless",
> you're just returning 32-bit values to the user, just use
> a u32 inside of the drm_radeon_info structure for the kernel
> to place the result in.

The plan for that was to expand it later, for now 32-bit was all we used.

Dave.
