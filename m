Return-Path: <linux-kernel-owner+w=401wt.eu-S1752133AbYIXMFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133AbYIXMFW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 08:05:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752254AbYIXMEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 08:04:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:59486 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142AbYIXMEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 08:04:51 -0400
Date: Wed, 24 Sep 2008 05:04:58 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Alan Jenkins <aj504@student.cs.york.ac.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: fastboot: usbmon WARNING
Message-ID: <20080924050458.34e42aed@infradead.org>
In-Reply-To: <48DA1967.3000801@tuffmail.co.uk>
References: <20080920110036.302261c7@infradead.org>
	<48DA1967.3000801@tuffmail.co.uk>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Sep 2008 11:41:43 +0100
Alan Jenkins <aj504@student.cs.york.ac.uk> wrote:

> Arjan van de Ven wrote:
> > The fastboot.git tree has a set of patches (all posted and reviewed
> > on lkml before) that speed up the kernel boot process of the kernel.
> > 
> > There's 3 major pieces of this
> > 1) The creation of an asynchronous initcall level (6a) that runs
> > asynchronous from the regular driver init, and is for non-boot
> > critical initcalls only 2) A rework of the non-initrd boot code to
> > try mounting /, and if that fails, only THEN wait for all the
> > various driver probings to finish (and then retry) 3) A tool
> > "bootgraph.pl" that outputs a SVG graphic of where the kernel boot
> > spends its time 
> 
> Enabling fastboot makes usbmon (CONFIG_USB_MON) squawk, trying to
> create duplicate sysfs files.

this got fixed but the fix is in gregkh's USB tree ...
