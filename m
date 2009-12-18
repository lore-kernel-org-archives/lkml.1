Return-Path: <linux-kernel-owner+w=401wt.eu-S1752260AbZLRIQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260AbZLRIQ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 03:16:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751402AbZLRIQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 03:16:57 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:57655 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbZLRIQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 03:16:56 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Dave Airlie <airlied@gmail.com>
Subject: Re: [PATCH] drm: convert drm_ioctl to unlocked_ioctl
Date: Fri, 18 Dec 2009 09:16:27 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.sourceforge.net,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
References: <200912162217.09577.arnd@arndb.de> <21d7e9970912171727i7576b1d9q1a8195ad884592a1@mail.gmail.com>
In-Reply-To: <21d7e9970912171727i7576b1d9q1a8195ad884592a1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912180916.27201.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19AMH9t0XGOj91Vf0EB2k7CIHE6eP3JQDKLuxi
 TqIb1LG9n+EtWOZjtwxryBrHT+Fvl1n7g6dW5/BXLiQeGaop1L
 lZ+6FapXFQrgUvvBWjwaw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 December 2009, Dave Airlie wrote:
> This looks good, I've taken this and I've squashed
> the generic pieces of your RFC into this (i.e.
> I haven't modified the drivers, but just added the
> flag to allow the ioctls to be unlocked if the driver
> selects them).
> 
> Do you think we should try and get this in soon,
> its seems like it shouldn't have any regressions
> unless we start switching drivers over.

Well, since the patch should not change the behaviour
of the drivers, it probably doesn't matter to users
either way. However, it touches a number of places,
which can break patches that others are working on,
so maybe you should get it upstream at a point that
has the least impact to developer (possibly now).

Doing it now at least makes it easier to test
moving drivers to unlocked operation.

	Arnd
