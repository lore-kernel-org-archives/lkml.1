Return-Path: <linux-kernel-owner+w=401wt.eu-S1758979AbXIJM3H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758979AbXIJM3H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 08:29:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757969AbXIJM2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 08:28:54 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:42783 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757386AbXIJM2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 08:28:52 -0400
Date: Mon, 10 Sep 2007 13:28:38 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Adrian Bunk <bunk@kernel.org>, rth@twiddle.net, hskinnemoen@atmel.com,
       uclinux-dist-devel@blackfin.uclinux.org, dev-etrax@axis.com,
       dhowells@redhat.com, discuss@x86-64.org, linux-ia64@vger.kernel.org,
       linux-mips@linux-mips.org, parisc-linux@parisc-linux.org,
       sparclinux@vger.kernel.org, chris@zankel.net
Subject: Re: [PATCH 2/2] forbid asm/bitops.h direct inclusion
Message-ID: <20070910122838.GA10143@linux-mips.org>
References: <30483262301654323266@pripojeni.net> <276116173913632310@pripojeni.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <276116173913632310@pripojeni.net>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 08, 2007 at 09:00:48PM +0100, Jiri Slaby wrote:

> forbid asm/bitops.h direct inclusion
> 
> Because of compile errors that may occur after bit changes if asm/bitops.h is
> included directly without e.g. linux/kernel.h which includes linux/bitops.h, forbid
> direct inclusion of asm/bitops.h. Thanks to Adrian Bunk.

This is the kind of thing that checkpatch.pl is already checking for and
I like that idea much more than adding thousands of checks over many of
the header files under asm.

  Ralf
