Return-Path: <linux-kernel-owner+w=401wt.eu-S1755982AbYDLQ4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982AbYDLQ4v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 12:56:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754254AbYDLQ4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 12:56:42 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59627 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217AbYDLQ4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 12:56:41 -0400
Date: Sat, 12 Apr 2008 09:59:19 -0700
From: Greg KH <greg@kroah.com>
To: "Rachmel, Nir (Nir)" <rachmel@avaya.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Kernel Oops on hot insertion of USB
Message-ID: <20080412165919.GA30848@kroah.com>
References: <11486DD9B957EA488E21C44BC8737EFC987F23@307622ANEX5.global.avaya.com> <20080412042918.GA13154@kroah.com> <11486DD9B957EA488E21C44BC8737EFC55F379@307622ANEX5.global.avaya.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11486DD9B957EA488E21C44BC8737EFC55F379@307622ANEX5.global.avaya.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A: No.
Q: Should I include quotations after my reply?

On Sat, Apr 12, 2008 at 11:20:08AM +0200, Rachmel, Nir (Nir) wrote:
> Hi greg,
>  
> Thanks for your reply. I am aware that I am "a bit" far behind in the
> Linux revsions tree,

Just a "bit", if you consider almost 3 years and many hundreds of
thousands of changes a "bit" :)

> however it will be very difficult for me to upgrade.

Why?  Userspace should work just fine.  If you are relying on custom
kernel modules, well, I think you now know the reason the kernel
developers are saying for people to get their code upstream to prevent
this kind of issue...

> I have done much work and testing with 2.6.14.7 and would
> prefer to patch it over upgrading it to the current version.

Hopefully you are able to patch all of the bugs and security issues that
have been found in the past 3 years.

> Was this problem fixed in a specific revision, or was the fix
> introduced due to several fixes in different areas? Maybe I can look
> at the specific fix and implement it on my own version.

All of our changes are public, I would suggest going through them and
trying to find it.  Because you are relying on such an old, outdated,
and unsupported kernel version, you really are on your own.

good luck,

greg k-h
