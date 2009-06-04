Return-Path: <linux-kernel-owner+w=401wt.eu-S1754497AbZFDSOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497AbZFDSOy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 14:14:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753969AbZFDSOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 14:14:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51337 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754078AbZFDSN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 14:13:57 -0400
Date: Thu, 4 Jun 2009 11:07:01 -0700
From: Greg KH <gregkh@suse.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for June 4 (staging)
Message-ID: <20090604180701.GA24896@suse.de>
References: <20090604175657.1565ecba.sfr@canb.auug.org.au> <4A27EEB8.6030408@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A27EEB8.6030408@oracle.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 08:56:40AM -0700, Randy Dunlap wrote:
> Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20090603:
> 
> drivers/staging/vt6655/built-in.o: In function `rotr1':
> (.text+0x1a883): multiple definition of `rotr1'
> drivers/staging/rt2860/built-in.o:(.text+0x17a9a): first defined here
> drivers/staging/vt6655/built-in.o: In function `tkip_sbox':
> (.text+0x1a850): multiple definition of `tkip_sbox'
> drivers/staging/rt2860/built-in.o:(.text+0x17a6b): first defined here
> drivers/staging/vt6655/built-in.o: In function `xor_32':
> (.text+0x1e938): multiple definition of `xor_32'
> drivers/staging/rt2860/built-in.o:(.text+0x1803c): first defined here
> drivers/staging/vt6655/built-in.o: In function `xor_128':
> (.text+0x1e910): multiple definition of `xor_128'
> drivers/staging/rt2860/built-in.o:(.text+0x18018): first defined here

Ick, more staging drivers that should not be built-in.  I'll go mess
with some Kconfig options...

thanks,

greg k-h
