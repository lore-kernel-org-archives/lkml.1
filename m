Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1751978AbYLQVvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978AbYLQVvJ (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 16:51:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751633AbYLQVuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 16:50:54 -0500
Received: from gw.goop.org ([64.81.55.164]:55082 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495AbYLQVux (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 16:50:53 -0500
Message-ID: <4949743C.2040306@goop.org>
Date: Wed, 17 Dec 2008 13:50:52 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: mingo@elte.hu, viro@ftp.linux.org.uk, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, alex.zeffertt@eu.citrix.com,
        Ian.Campbell@citrix.com
Subject: Re: [PATCH UPDATED] xen: add xenfs to allow usermode <-> Xen interaction
References: <49480F39.2010102@goop.org>	<20081216125425.30524946.akpm@linux-foundation.org>	<49496E17.2010703@goop.org> <20081217133429.b64e6421.akpm@linux-foundation.org>
In-Reply-To: <20081217133429.b64e6421.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> I'm bored of your filesystem, so I think I'll just merge it, unless
> someone else wants to ;)
>   

Yay!  Boring code Wins!

> Was this noticed and considered?
>
> WARNING: consider using strict_strtoul in preference to simple_strtoul
> #543: FILE: drivers/xen/xenfs/xenbus.c:315:
> +               trans->handle.id = simple_strtoul(reply, NULL, 0);
>   

Noticed that, but wasn't sure how to handle an error there anyway.  
Something pretty horrible must have happened at the other end.

    J
