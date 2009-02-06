Return-Path: <linux-kernel-owner+w=401wt.eu-S1757562AbZBFJe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757562AbZBFJe5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 04:34:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758650AbZBFJeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 04:34:15 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37369 "EHLO
	the-village.bc.nu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758621AbZBFJeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 04:34:12 -0500
Date: Fri, 6 Feb 2009 10:06:07 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bryan Wu <cooloney@kernel.org>
Cc: linux-kernel@vger.kernel.org, Sonic Zhang <sonic.zhang@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: Re: [PATCH] tty: fix bug - kernel can't be pinged through when
 bootargs console=null
Message-ID: <20090206100607.277d83e2@the-village.bc.nu>
In-Reply-To: <1233908877-7729-1-git-send-email-cooloney@kernel.org>
References: <1233908877-7729-1-git-send-email-cooloney@kernel.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  6 Feb 2009 16:27:57 +0800
Bryan Wu <cooloney@kernel.org> wrote:

> From: Sonic Zhang <sonic.zhang@analog.com>
> 
> when pass bootargs console=null into kernel from u-boot, the booted up
> kernel can't be pinged through. This happens after the kernel is upgraded
> to 2.6.28.
> 
> Should check if tty_driver is NULL before call kref_get() in tty_driver_kref_get().

Should not call tty_driver_kref_get(NULL) in the first place....

Need to fix the real bug not paper over it
