Return-Path: <linux-kernel-owner+w=401wt.eu-S1422778AbXDYW06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422778AbXDYW06 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 18:26:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422813AbXDYW06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 18:26:58 -0400
Received: from smtp.ono.com ([62.42.230.12]:41538 "EHLO resmaa03.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1422778AbXDYW05 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 18:26:57 -0400
Date: Thu, 26 Apr 2007 00:26:41 +0200
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: start_udev and devpts [Re: 2.6.21-rc6-mm1]
Message-ID: <20070426002641.5a781a77@werewolf-wl>
In-Reply-To: <20070425233954.1c8601da@werewolf-wl>
References: <20070408143559.f5014629.akpm@linux-foundation.org>
	<20070424101041.2fb2d9e0@werewolf-wl>
	<20070424045801.607b30d4.akpm@linux-foundation.org>
	<20070424154321.11c70ace@werewolf-wl>
	<20070424102250.ab8469bd.akpm@linux-foundation.org>
	<20070425225039.1cf6c1ee@werewolf-wl>
	<20070425233954.1c8601da@werewolf-wl>
X-Mailer: Claws Mail 2.9.1cvs23 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Apr 2007 23:39:54 +0200, "J.A. Magallón" <jamagallon@ono.com> wrote:

> On Wed, 25 Apr 2007 22:50:39 +0200, "J.A. Magallón" <jamagallon@ono.com> wrote:
...
> 
> But I think I found the problem.
> In short, in /dev/pts is mounted before /dev. I remounted it and ssh worked
> fine again.
> I'll dig mandrivas rc's to check this...
> 
> Anyways, I see no plain 'mount' command in /sbin/start_udev, all are 
> 'mount --move' commands. So I think it supposes is already mounted and
> tries to move it.
> 

As a (in)famous last work, I think Unix98 PTYs really don't like mount --move
for /dev/pts. If I mount it manually after boot, everything works fine.

--
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2008.0 (Cooker) for i586
Linux 2.6.20-jam10 (gcc 4.1.2 20070302 (prerelease) (4.1.2-1mdv2007.1)) #4 SMP PREEMPT
