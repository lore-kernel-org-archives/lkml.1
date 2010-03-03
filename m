Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758303Ab0CCAUo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 19:20:44 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58965 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754635Ab0CCAUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 19:20:40 -0500
Date: Tue, 2 Mar 2010 16:19:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rick L. Vinyard Jr." <rvinyard@cs.nmsu.edu>
Cc: linux-kernel@vger.kernel.org, felipe.balbi@nokia.com, pavel@ucw.cz,
       jayakumar.lkml@gmail.com, linux-usb@vger.kernel.org, oliver@neukum.org,
       linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
       npavel@ituner.com, tomi.valkeinen@nokia.com, tony@atomide.com,
       FlorianSchandinat@gmx.de, krzysztof.h1@wp.pl,
       linux-fbdev@vger.kernel.org, jkosina@suse.cz, bonbons@linux-vserver.org
Subject: Re: [PATCH] Add sysfs support for fbdefio delay
Message-Id: <20100302161919.19df3a18.akpm@linux-foundation.org>
In-Reply-To: <201003021847.o22IlYR8004349@mustang.cs.nmsu.edu>
References: <201003021847.o22IlYR8004349@mustang.cs.nmsu.edu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Mar 2010 11:47:34 -0700
"Rick L. Vinyard Jr." <rvinyard@cs.nmsu.edu> wrote:

> This patch adds support for examining and modifying the fbdefio delay
> parameter through sysfs. It also adds two driver definable minimum
> and maximum bounds.
> 
> The default behavior is to not permit modifications if delay_max is 0,
> thus preventing modification of the delay if the driver does not
> explicitly permit modification.

Why is this being added?  You have some device which doesn't function
properly without this change?

If so, that's pretty critical changelog info - we presently have no
reason to merge the patch!

Thanks.

