Return-Path: <linux-kernel-owner+w=401wt.eu-S1759916AbXIIUjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759916AbXIIUjz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 16:39:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758909AbXIIUjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 16:39:42 -0400
Received: from lixom.net ([66.141.50.11]:50590 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759740AbXIIUjk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 16:39:40 -0400
Date: Sun, 9 Sep 2007 15:40:17 -0500
From: Olof Johansson <olof@lixom.net>
To: Adrian Bunk <bunk@kernel.org>
Cc: paulus@samba.org, linuxppc-dev@ozlabs.org, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] powerpc: proper defconfig for crosscompiles
Message-ID: <20070909204017.GA7275@lixom.net>
References: <20070909182117.GJ3563@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070909182117.GJ3563@stusta.de>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 09, 2007 at 08:21:17PM +0200, Adrian Bunk wrote:
> The trick for finding the right defconfig is neat, but you forgot to 
> provide an i686_defconfig.  ;-)
> 
> More seriously, cross compiling the defconfig is often useful, e.g. for 
> testing the compilation of patches that touch multiple architectures, 
> and this patch therefore chooses g5_defconfig if $(CROSS_COMPILE) is 
> non-empty.

You should probably use ppc64_defconfig instead, since it's the "superset"
config that will compile a multiplatform kernel.


-Olof

