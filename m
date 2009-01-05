Return-Path: <linux-kernel-owner+w=401wt.eu-S1754682AbZAELrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682AbZAELrx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 06:47:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752949AbZAELrn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 06:47:43 -0500
Received: from 1wt.eu ([62.212.114.60]:1091 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751957AbZAELrm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 06:47:42 -0500
Date: Mon, 5 Jan 2009 12:47:30 +0100
From: Willy Tarreau <w@1wt.eu>
To: Ian Campbell <ijc@hellion.org.uk>
Cc: Martin Schlemmer <Martin.Schlemmer@nwu.ac.za>,
       linux-kernel@vger.kernel.org
Subject: Re: Initramfs from existing vmlinuz
Message-ID: <20090105114730.GD3268@1wt.eu>
References: <49518245.3D93.006F.0@nwu.ac.za> <20081223233410.GC6800@1wt.eu> <1231153946.2648.49.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231153946.2648.49.camel@zakaz.uk.xensource.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2009 at 11:12:26AM +0000, Ian Campbell wrote:
> On Wed, 2008-12-24 at 00:34 +0100, Willy Tarreau wrote:
> > You first have to extract and uncompress the ELF image from vmlinuz.
> > For this, look for the gzip signature 1F 8B 08 in your vmlinuz, and
> > feed all data starting from this point to zcat.
> 
> Since v2.6.26 (I think, it was v2.08 of the x86 bzImage format anyhow,
> which was the same point the payload became ELF formatted) you can find
> it directly using the payload_offset and payload_length fields in the
> bzImage header. Attached bzexplode.c demonstrates this. e.g. "bzexplode
> vmlinuz | zcat > vmlinux.elf"

Thanks Ian.

Indeed, I'm sure this will be useful from time to time!

Cheers,
Willy

