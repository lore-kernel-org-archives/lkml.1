Return-Path: <linux-kernel-owner+w=401wt.eu-S1754096AbZANSLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096AbZANSLT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 13:11:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752970AbZANSLB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 13:11:01 -0500
Received: from mx2.suse.de ([195.135.220.15]:39731 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752091AbZANSLA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 13:11:00 -0500
Date: Wed, 14 Jan 2009 10:04:03 -0800
From: Greg KH <gregkh@suse.de>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUILD-FAILURE] next-20090114 - drivers/staging/meilhaus
Message-ID: <20090114180403.GA16974@suse.de>
References: <20090114165002.3bbe49d7.sfr@canb.auug.org.au> <20090114180024.GB4796@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090114180024.GB4796@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 11:30:24PM +0530, Kamalesh Babulal wrote:
> Hi Stephen,
> 
> 	next-20090114 randconfig build on x86_64 machine fails,
> 
>   LD      drivers/staging/meilhaus/built-in.o
> drivers/staging/meilhaus/me1600.o: In function `cleanup_module':
> (.exit.text+0x0): multiple definition of `cleanup_module'
> drivers/staging/meilhaus/memain.o:memain.c:(.exit.text+0x0): first defined here

Yeah, a lot of these staging drivers can't handle being built into the
kernel.

At first glance, I don't see a way to prevent this, is there some
Kconfig option I can use to say, "this can only be a module or disabled,
not build statically"?

thanks,

greg k-h
