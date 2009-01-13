Return-Path: <linux-kernel-owner+w=401wt.eu-S1757349AbZAMXYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349AbZAMXYx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 18:24:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755127AbZAMXYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 18:24:41 -0500
Received: from ns.suse.de ([195.135.220.2]:37973 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753383AbZAMXYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 18:24:40 -0500
Date: Tue, 13 Jan 2009 15:00:58 -0800
From: Greg KH <gregkh@suse.de>
To: Erik Ekman <erik@kryo.se>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [STAGING] comedi breaks build
Message-ID: <20090113230058.GI24682@suse.de>
References: <20090110142830.26ad46b8.erik@kryo.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090110142830.26ad46b8.erik@kryo.se>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2009 at 02:28:30PM +0100, Erik Ekman wrote:
> Comedi does not build:
> 
> drivers/staging/comedi/kcomedilib/built-in.o: In function `comedi_unmap':
> (.text+0x499): multiple definition of `comedi_unmap'
> drivers/staging/comedi/comedi.o:(.text+0x18): first defined here
> make[3]: *** [drivers/staging/comedi/built-in.o] Error 1
> make[2]: *** [drivers/staging/comedi] Error 2
> make[1]: *** [drivers/staging] Error 2
> 
> comedi_unmap() exists both in
> drivers/staging/comedi/kcomedilib/kcomedilib_main.c and
> drivers/staging/comedi/comedi_fops.c
> 

Yeah, comedi doesn't like to be built into the kernel, I'm working on
that.

thanks,

greg k-h
