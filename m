Return-Path: <linux-kernel-owner+w=401wt.eu-S1754295AbZDFAlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295AbZDFAlv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 20:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbZDFAlm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 20:41:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:41653 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbZDFAlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 20:41:42 -0400
Subject: Re: Staging: sxg: Add support to download the firmware using
 request_firmware()
From: David Woodhouse <dwmw2@infradead.org>
To: Greg Kroah-Hartman <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Mithlesh Thukral <mithlesh@linsyssoft.com>,
       Christopher Harrer <charrer@alacritech.com>
In-Reply-To: <200904051919.n35JJUUq031448@hera.kernel.org>
References: <200904051919.n35JJUUq031448@hera.kernel.org>
Content-Type: text/plain
Date: Sun, 05 Apr 2009 17:41:33 -0700
Message-Id: <1238978493.11870.2.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 (2.26.0-2.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-04-05 at 19:19 +0000, Linux Kernel Mailing List wrote:
> Gitweb:     http://git.kernel.org/linus/cda3b517a478324233d9be71232b60e2e2efe848
> Commit:     cda3b517a478324233d9be71232b60e2e2efe848
> Parent:     e5ea8da06ba610551a75c79c1467aae379e953ce
> Author:     Mithlesh Thukral <mithlesh@linsyssoft.com>
> AuthorDate: Fri Mar 20 17:39:04 2009 +0530
> Committer:  Greg Kroah-Hartman <gregkh@suse.de>
> CommitDate: Fri Apr 3 14:53:14 2009 -0700
> 
>     Staging: sxg: Add support to download the firmware using request_firmware()
>     
>     Add support for downloading the firmware using kernel-builtin mechanism.
>     This will remove the need for the firmware files in the driver source code.
>     
>     Signed-off-by: Christopher Harrer <charrer@alacritech.com>
>     Signed-off-by: Mithlesh Thukral <mithlesh@linsyssoft.com>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> ---
>  drivers/staging/sxg/saharadbgdownload-1.71.c  | 5233 ------------------------
>  drivers/staging/sxg/saharadbgdownloadB-1.10.c | 5251 -------------------------
>  drivers/staging/sxg/saharadownload-1.55.c     | 4531 ---------------------
>  drivers/staging/sxg/saharadownloadB-1.8.c     | 4532 ---------------------
>  drivers/staging/sxg/sxg.c                     |  206 +-
>  firmware/Makefile                             |    2 +
>  firmware/WHENCE                               |   12 +
>  firmware/sxg/saharadbgdownloadB.sys.ihex      | 3937 ++++++++++++++++++
>  firmware/sxg/saharadownloadB.sys.ihex         | 3385 ++++++++++++++++
>  9 files changed, 7437 insertions(+), 19652 deletions(-)

NO!

What the hell are you playing at, Greg?

We don't want to be adding _new_ binary firmware into the firmware/
directory -- that was only the temporary location for removing the
_existing_ crap.

We have the linux-firmware.git repository, into which we are collecting
new firmware blobs. Don't add them to the kernel sources.

This whole 'staging' clusterfuck is getting out of hand.

-- 
dwmw2

