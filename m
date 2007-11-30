Return-Path: <linux-kernel-owner+w=401wt.eu-S1757343AbXK3Vhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757343AbXK3Vhm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 16:37:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756530AbXK3VhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 16:37:20 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54682 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756440AbXK3VhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 16:37:18 -0500
Date: Fri, 30 Nov 2007 13:36:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: jirislaby@gmail.com, mhoffman@lightlink.com, linux-kernel@vger.kernel.org,
       r.marek@assembler.cz, lm-sensors@lm-sensors.org
Subject: Re: [PATCH 1/1] HWMON: coretemp, suspend fix
Message-Id: <20071130133632.e1781b57.akpm@linux-foundation.org>
In-Reply-To: <200711301746.19447.rjw@sisk.pl>
References: <661416096128474967.slaby@pripojeni.net>
	<200711301746.19447.rjw@sisk.pl>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Nov 2007 17:46:18 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Friday, 30 of November 2007, Jiri Slaby wrote:
> > Ok, I don't see it merged in the latest -mm (mmotm). Could you, Mark, Rafael,
> > sign off this version of the patch (Mark's + Rafael's fix)?
> > 
> > --
> > 
> > From: Mark M. Hoffman <mhoffman@lightlink.com>
> > 
> > coretemp, suspend fix
> > 
> > It's not permitted to unregister device/cpu if frozen and going to sleep.
> > It causes deadlock on systems, where coretemp hwmon is loaded. Do it only
> > in non-freezed states instead.
> > 
> > Cc: Rafael J. Wysocki <rjw@sisk.pl> (frozen fix)
> > Cc: Mark M. Hoffman <mhoffman@lightlink.com>

Should that have been signed-off-by:Mark?

> > Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

So I'll assume this is for-2.6.24, to-be-merged-by-me.  If it turns up in
Mark's tree (or anyone else's) then I'll drop it and forget all about it.
Which is OK, as long as whoever-merged-it remembers to get it into 2.6.24.

