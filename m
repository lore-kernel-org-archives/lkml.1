Return-Path: <linux-kernel-owner+w=401wt.eu-S1753323AbZG1PUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbZG1PUy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 11:20:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750961AbZG1PUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 11:20:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52572 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750842AbZG1PUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 11:20:52 -0400
Date: Tue, 28 Jul 2009 08:13:09 -0700
From: Greg KH <gregkh@suse.de>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Nicolas Palix <npalix@diku.dk>, hjanssen@microsoft.com,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: hv: Transform PDEVICE_OBJECT and
 DEVICE_OBJECT typedefs into their corresponding structs
Message-ID: <20090728151309.GA14956@suse.de>
References: <200907281030.45317.npalix@diku.dk>
 <20090728144123.GB13883@suse.de>
 <200907281701.43509.npalix@diku.dk>
 <20090728150716.GH3711@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090728150716.GH3711@parisc-linux.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 28, 2009 at 09:07:16AM -0600, Matthew Wilcox wrote:
> On Tue, Jul 28, 2009 at 05:01:42PM +0200, Nicolas Palix wrote:
> > Ok. So, I guess the pattern for the other typedef is to strip the _OBJECT
> > suffix when present, and always add the prefix hv_, right ?
> 
> The 'pattern' is to look at what the code is doing and choose a sensible
> name.

Heh, yes.  It can be hard, I know I suck at picking names for structures
and functions at times, but try to make it unique and descriptive for
what it is doing.

thanks,

greg "struct class" k-h
