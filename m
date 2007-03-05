Return-Path: <linux-kernel-owner+w=401wt.eu-S1752643AbXCEE1I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643AbXCEE1I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 23:27:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752642AbXCEE1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 23:27:08 -0500
Received: from ozlabs.org ([203.10.76.45]:56966 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752636AbXCEE1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 23:27:07 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17899.39250.247475.777798@cargo.ozlabs.ibm.com>
Date: Mon, 5 Mar 2007 15:15:14 +1100
From: Paul Mackerras <paulus@samba.org>
To: Gerd Hoffmann <kraxel@suse.de>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>, benh@kernel.crashing.org
Subject: Re: [patch] Fixes and cleanups for earlyprintk aka boot console.
In-Reply-To: <45DADD15.7070809@suse.de>
References: <45DADD15.7070809@suse.de>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gerd Hoffmann writes:

> This patch fixes the console selection code to *not* consider a boot
> console a full-featured one, so the first non-boot console registering
> will become the default console instead.  This way the unregister call
> for the boot console in the register_console() function actually
> triggers and the handover from the boot console to the real console
> device works smoothly.  Added a printk for the handover, so you know
> which console device the output goes to when the boot console stops
> printing messages.

You have removed functionality that is useful for debugging, that 3
architectures had, namely a way to keep using the early boot console
and not replace it with a console that comes later, using a kernel
command line option.  Perhaps you could provide a way to do that in
your patch.

Paul.

