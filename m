Return-Path: <linux-kernel-owner+w=401wt.eu-S1752711AbXLCQDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711AbXLCQDS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 11:03:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750964AbXLCQDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 11:03:10 -0500
Received: from ftp.linux-mips.org ([194.74.144.162]:44118 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbXLCQDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 11:03:09 -0500
Date: Mon, 3 Dec 2007 16:00:11 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: David Howells <dhowells@redhat.com>
Cc: Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] Suppress A.OUT library support if
	!CONFIG_BINFMT_AOUT [try #5]
Message-ID: <20071203160011.GA9058@linux-mips.org>
References: <20071111112538.GL21669@stusta.de> <20071109153432.20803.69832.stgit@warthog.procyon.org.uk> <20071109153437.20803.55096.stgit@warthog.procyon.org.uk> <18452.1196694929@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18452.1196694929@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03, 2007 at 03:15:29PM +0000, David Howells wrote:

> > - it adds #ifdef's in fs/binfmt_elf.c for code that is anyway
> >   scheduled for removal in 2.6.25
> 
> I'm told (by Ralf) that removing this support will break Castle Wolfenstein or
> something like that.
> 
> So unless you want hordes of rampaging MIPS users breaking down your door
> whilst waving pitchforks and torches, maybe this needs to be reconsidered...

The wonders of asynchronous IRC communication ...

Wolfenstein is a true a.out binary and for a long time it was _the_ a.out
binary.  If it was working no user would complain ;-)

  Ralf
