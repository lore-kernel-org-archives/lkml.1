Return-Path: <linux-kernel-owner+w=401wt.eu-S1759317AbYB2GV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759317AbYB2GV1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 01:21:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755208AbYB2GVD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 01:21:03 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:56656 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754884AbYB2GVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 01:21:00 -0500
Date: Thu, 28 Feb 2008 22:19:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Mark Pearson <devnull.port@googlemail.com>,
       Karol Kozimor <sziwan@hell.org.pl>, Julia Lawall <julia@diku.dk>,
       corentincj@iksaif.net, sziwan@users.sourceforge.net,
       acpi4asus-user@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org, Len Brown <lenb@kernel.org>
Subject: Re: [PATCH 2/9] drivers/acpi/asus_acpi.c: Correct use of ! and &
Message-Id: <20080228221948.2602527a.akpm@linux-foundation.org>
In-Reply-To: <20080229061023.GD19198@parisc-linux.org>
References: <Pine.LNX.4.64.0802262142120.18200@ask.diku.dk>
	<7C626792-02A6-4BE6-B5F2-D75899F3990C@hell.org.pl>
	<47C5ABFB.3050607@googlemail.com>
	<20080228215503.b942bb3c.akpm@linux-foundation.org>
	<20080229061023.GD19198@parisc-linux.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Feb 2008 23:10:23 -0700 Matthew Wilcox <matthew@wil.cx> wrote:

> On Thu, Feb 28, 2008 at 09:55:03PM -0800, Andrew Morton wrote:
> >  	if (invert)		/* invert target value */
> > -		led_out = !led_out & 0x1;
> > +		led_out = !led_out;
> >  
> >  	if (!write_acpi_int(hotk->handle, ledname, led_out, NULL))
> 
> But now you're writing 0xffffffff instead of 1.  I think the suggestion
> of led_out ^= 1 was the correct one.
> 

!0 is 1, not 0xffffffff.

IOW, ! != ~ ;)


