Return-Path: <linux-kernel-owner+w=401wt.eu-S1756222AbZAAIZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222AbZAAIZx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 03:25:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752364AbZAAIZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 03:25:45 -0500
Received: from 1wt.eu ([62.212.114.60]:1028 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342AbZAAIZo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 03:25:44 -0500
Date: Thu, 1 Jan 2009 09:27:46 +0100
From: Willy Tarreau <w@1wt.eu>
To: david@lang.hm
Cc: Roland <devzero@web.de>, linux-kernel@vger.kernel.org,
       Jan Engelhardt <jengelh@medozas.de>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] Compress kernel modules on installation
Message-ID: <20090101082746.GA5038@1wt.eu>
References: <005401c96797$df055100$6602a8c0@bui.materna.com> <alpine.DEB.1.10.0812261354250.10983@asgard.lang.hm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0812261354250.10983@asgard.lang.hm>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 26, 2008 at 02:02:37PM -0800, david@lang.hm wrote:
> On Fri, 26 Dec 2008, Roland wrote:
> 
> >what about some "make modules_install_compressed" instead ?
> >
> >as i have run out of diskspace quite often when installing test kernels, i 
> >think we really need a feature like this.
> >
> >i`d also favour the makefile approach.
> >why another kconfig option?
> >
> >jan`s patch looks clean and simple, but i think it`s a little bit 
> >intrusive...
> 
> by default the main kernel is compressed, why should the modules not be 
> compressed by default as well?

I've always compressed my modules for years, and I can say there is *one*
situation where I uncompress them, it's before making an initrd or initramfs,
because compressing an FS with many compressed files leads to a fairly bigger
image than leaving them uncompressed on the compressed FS.

Willy

