Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758802Ab0BYBwz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 20:52:55 -0500
Received: from mail-ww0-f46.google.com ([74.125.82.46]:36264 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758790Ab0BYBwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 20:52:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=v04ZrhzXK9iStX549/1a8RUmGs5LgUb7HShcXSmNeRFw8itjlTbgPAhdCq/7I/XoWs
         S27Jh/HOosEZ7BFhdrjRimK4ktxb3EeuqNiFz+g2krJwHlC+C4UXuFyuMhrSjDsdPUNn
         C9dkxdGBRBDZ9iYcYCzdxgvhuXGmkyBHvkkMY=
MIME-Version: 1.0
In-Reply-To: <1266867811.10646.196.camel@Joe-Laptop.home>
References: <20100222141934.GA9030@darkstar>
	 <1266867811.10646.196.camel@Joe-Laptop.home>
Date: Thu, 25 Feb 2010 09:52:49 +0800
Message-ID: <a8e1da1002241752u637f7debi2ff46f50ac5edcd8@mail.gmail.com>
Subject: Re: [PATCH 03/06] kernel.h hexdump cleanup
From: Dave Young <hidave.darkstar@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>, Li Zefan <lizf@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 23, 2010 at 3:43 AM, Joe Perches <joe@perches.com> wrote:
> On Mon, 2010-02-22 at 22:19 +0800, Dave Young wrote:
>> hexdump stuff in kernel.h should be put into a standalone head file
>
> I think it'd be clearer to have logging functions
> in kernel.h split into a separate header or grouped
> a bit better in kernel.h.
>
> I would have kernel.h #include that header though
> rather than splitting out things like hexdump functions
> into a separate file requiring yet another #include in
> source files.

Andrew, what do you think about this?

Actually I hesitate to send this patch as well, too many recipients
needed from get_maintainer.pl.

>
> http://lkml.org/lkml/2009/12/16/77
> http://lkml.org/lkml/2007/11/29/507
>
>
>



-- 
Regards
dave
