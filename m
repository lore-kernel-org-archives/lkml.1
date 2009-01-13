Return-Path: <linux-kernel-owner+w=401wt.eu-S1759309AbZAMXYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759309AbZAMXYd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 18:24:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753383AbZAMXYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 18:24:23 -0500
Received: from mx1.suse.de ([195.135.220.2]:37946 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751936AbZAMXYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 18:24:22 -0500
Date: Tue, 13 Jan 2009 14:47:48 -0800
From: Greg KH <gregkh@suse.de>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: ds@schleef.org, fmhess@users.sourceforge.net, linux-kernel@vger.kernel.org,
       erik@kryo.se, randy.dunlap@oracle.com, sfr@canb.auug.org.au
Subject: Re: [BUILD-FAILURE] 2.6.29-rc1-git2 - staging/comedi_unmap driver
	fails to build
Message-ID: <20090113224748.GD24682@suse.de>
References: <20090113090305.GA2364@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090113090305.GA2364@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 02:33:05PM +0530, Kamalesh Babulal wrote:
> Hi David,
> 
> 	comedi driver randconfig build fails on the 2.6.29-rc1 kernel,
> 
> drivers/staging/comedi/kcomedilib/built-in.o: In function `comedi_unmap':
> (.text+0x489): multiple definition of `comedi_unmap'
> drivers/staging/comedi/comedi.o:(.text+0xcf): first defined here
> ld: Warning: size of symbol `comedi_unmap' changed from 48 in drivers/staging/comedi/comedi.o to 41 in drivers/staging/comedi/kcomedilib/built-in.o
> make[3]: *** [drivers/staging/comedi/built-in.o] Error 1

Yeah, comedi doesn't like to be built into the kernel, I'll work on
resolving this...

thanks,

greg k-h
