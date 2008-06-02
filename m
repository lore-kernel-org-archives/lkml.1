Return-Path: <linux-kernel-owner+w=401wt.eu-S1758246AbYFBHDa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758246AbYFBHDa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 03:03:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752973AbYFBHDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 03:03:22 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:15001 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537AbYFBHDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 03:03:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=P6rSZL5gNR8fI04TSWU7xOIfAwbGtW0gCibDr8A8jGs9zWZAAKb4R1f0oWswQ4l2LJROtA/xH4d8IyNhpRGavbdn2uOb0hSvr5OH+rUydCYfT+nHVCnfo1YOxoffF6BSQfTG25ztmgr2nvFzL8H7HWMaqe2pz9VCb4TOQss6CLk=
Message-ID: <19f34abd0806020003ub40def1w9dc011a357367f02@mail.gmail.com>
Date: Mon, 2 Jun 2008 09:03:19 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: find: WARNING: Hard link count is wrong for /proc/1
Cc: "Pavel Emelyanov" <xemul@openvz.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <19f34abd0806020000h407e3fb1kadff228a3cf4c6f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0806012331m7c57468bu820e9b6b0184836d@mail.gmail.com>
	 <19f34abd0806020000h407e3fb1kadff228a3cf4c6f@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 2, 2008 at 9:00 AM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
...
> Will this do? (Untested)
>
> Vegard
>
>
> From a43ef05a8c1f8d45ca88e00fdd31c00ddfdba1b8 Mon Sep 17 00:00:00 2001
> From: Vegard Nossum <vegard.nossum@gmail.com>
> Date: Mon, 2 Jun 2008 08:57:45 +0200
> Subject: [PATCH] proc: fix /proc/<pid> link count
>
> commit e9720acd728a46cb40daa52c99a979f7c4ff195c
> Author: Pavel Emelyanov <xemul@openvz.org>
> Date:   Fri Mar 7 11:08:40 2008 -0800
>
>    [NET]: Make /proc/net a symlink on /proc/self/net (v3)
>
> introduced /proc/net without bumping the link count on /proc/self.

Oops ---^

Should say /proc/self/net. Sorry for the spamming.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
