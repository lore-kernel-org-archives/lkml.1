Return-Path: <linux-kernel-owner+w=401wt.eu-S1754073AbZDCEK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073AbZDCEK4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 00:10:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751088AbZDCEKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 00:10:47 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:35869 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750956AbZDCEKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 00:10:47 -0400
Date: Fri, 3 Apr 2009 00:10:45 -0400
To: Rob Landley <rob@landley.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: Re: make headers_install broken for ARCH=m68k in 2.6.29-rc7.
Message-ID: <20090403041045.GG3795@csclub.uwaterloo.ca>
References: <200903120437.03837.rob@landley.net> <200904012114.07183.rob@landley.net> <20090402215926.GD3795@csclub.uwaterloo.ca> <200904021924.36815.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904021924.36815.rob@landley.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 02, 2009 at 07:24:35PM -0500, Rob Landley wrote:
> Here I'm using bash 2.05b, using gcc 4.2.1 (last gplv2 release), building the 
> with-mmu target, and I haven't actually got a test environment to boot the 
> result in working yet, so yeah.

I don't want to go back to 4.2.x though, I want current "stable" releases. :)

4.3 did change the abi for m68knommu it seems, which has caused trouble
compiling uboot, although the kernel compiles and works fine.

bash compiles on nommu systems?  I suspect not.  Given I am working with
a coldfire 5271, mmu isn't an option, so I am stuck in crappy no fork
or other useful stuff land.  At least the main cpu is a nice sane powerpc
running proper linux.

-- 
Len Sorensen
