Return-Path: <linux-kernel-owner+w=401wt.eu-S1757107AbYGKUXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757107AbYGKUXq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 16:23:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760202AbYGKUXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 16:23:30 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45466 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760169AbYGKUX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 16:23:29 -0400
Date: Fri, 11 Jul 2008 21:05:16 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
       Russell King <rmk+lkml@arm.linux.org.uk>, linux-serial@vger.kernel.org,
       Bryan Wu <cooloney@kernel.org>
Subject: Re: [PATCH] serial8250: Sanity check nr_uarts on all paths.
Message-ID: <20080711210516.02a04245@lxorguk.ukuu.org.uk>
In-Reply-To: <m1wsjsdxr1.fsf@frodo.ebiederm.org>
References: <m1wsjsdxr1.fsf@frodo.ebiederm.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jul 2008 12:30:42 -0700
ebiederm@xmission.com (Eric W. Biederman) wrote:

> 
> 
> I had 8250.nr_uarts=16 in the boot line of a test kernel and I had a
> weird mysterious crash in sysfs.  After an taking in depth look I realized
> that CONFIG_SERIAL_8250_NR_UARTS was set to 4 and I was walking off
> the end of the serial8250_ports array.
> 
> Ouch!!!
> 
> Don't let this happen to someone else.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>

Acked-by: Alan Cox <alan@redhat.com>

Added to ttydev tree but please fire straight at Linus in case he fancies
it for 2.6.26
