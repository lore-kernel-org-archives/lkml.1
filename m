Return-Path: <linux-kernel-owner+w=401wt.eu-S1753837AbYIVU3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837AbYIVU3W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 16:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751753AbYIVU3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 16:29:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32884 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752001AbYIVU3M convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 16:29:12 -0400
Date: Mon, 22 Sep 2008 13:28:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bruno =?ISO-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: krzysztof.h1@poczta.fm, spock@gentoo.org,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [Linux-fbdev-devel] [PATCH] fbdev: don't allow to set a video
 mode via vga= if FB doesn't support it
Message-Id: <20080922132830.359bc001.akpm@linux-foundation.org>
In-Reply-To: <20080922220054.4e74c099@neptune.home>
References: <20080921210219.GC21215@spock.one.pl>
	<20080922214747.c8bc57eb.krzysztof.h1@poczta.fm>
	<20080922220054.4e74c099@neptune.home>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Sep 2008 22:00:54 +0200
Bruno Prémont <bonbons@linux-vserver.org> wrote:

> From: Michal Januszewski <spock@gentoo.org>
> > Currently, it is possible to set a VESA graphics mode at boot time
> > via the vga= parameter even when no framebuffer driver supporting
> > this is configured.  This could lead to the system booting with a
> > black screen, without a usable console.
> > 
> This looks pretty much the same as what I requested some time ago:
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=8062
> 
> Would need to check -mm archives for the actual patch.
> 
> Don't remember why it did not make it to mainline...

If someone can give me some idea of what that patch looked
like then I can go hunt it down, find out why it didn't make it.
