Return-Path: <linux-kernel-owner+w=401wt.eu-S970406AbXILRES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970406AbXILRES (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 13:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765753AbXILREI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 13:04:08 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:50452 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764759AbXILREG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 13:04:06 -0400
Date: Wed, 12 Sep 2007 19:05:29 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Dan Stromberg <dstromberglists@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Building a kernel-source RPM (not a kernel RPM)?
Message-ID: <20070912170529.GA18311@uranus.ravnborg.org>
References: <pan.2007.09.12.16.13.41.195991@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <pan.2007.09.12.16.13.41.195991@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2007 at 09:13:41AM -0700, Dan Stromberg wrote:
> 
> I sent this to kernel newbies first, and while I got one response there,
> it answered a different question than the one I was asking...
> 
> I'm on a SuSE system.
> 
> I'm working on automating the install of said system, but it needs a
> Linus kernel - 2.6.21.7 specifically, and it needs kernel source too so
> that we can build modules in the field as needed.
> 
> I see you can make an rpm of a bootable kernel with "make rpm".
> 
> Is there a streamlined way of building a corresponding kernel-source
> RPM?  Or do people pretty much all just dump the source in /usr/src, and
> manually update symlinks as needed?  If the latter, what symlinks need
> to be updated?

Being rpm ignorant I do not know what the expected content of a kernel-source RPM
are but this is the available targets for kernel packaging (from make help):

Kernel packaging:
  rpm-pkg         - Build the kernel as an RPM package
  binrpm-pkg      - Build an rpm package containing the compiled kernel
                    and modules
  deb-pkg         - Build the kernel as an deb package
  tar-pkg         - Build the kernel as an uncompressed tarball
  targz-pkg       - Build the kernel as a gzip compressed tarball
  tarbz2-pkg      - Build the kernel as a bzip2 compressed tarball


I just tried binrpm-pkg - but alas I have no rpm installed it failed.

	Sam
