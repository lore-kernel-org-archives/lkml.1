Return-Path: <linux-kernel-owner+w=401wt.eu-S1754887AbXJHVMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887AbXJHVMj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 17:12:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752722AbXJHVMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 17:12:30 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:47642 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752120AbXJHVM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 17:12:29 -0400
Date: Mon, 8 Oct 2007 23:12:56 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: kbuild devel <kbuild-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/RFT] kbuild: save ARCH & CROSS_COMPILE
Message-ID: <20071008211255.GP16424@stusta.de>
References: <20071008200255.GA16497@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071008200255.GA16497@uranus.ravnborg.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2007 at 10:02:55PM +0200, Sam Ravnborg wrote:
>...
> The settings are stored in the build directory in a file
> named "Kbuild.config" (should it be a .dot file?).
>...

A .dot file sounds better.

And even if not, generated files should IMHO not share the Kbuild* 
namespace with non-generated files.

Apart from this I like the patch.

> 	Sam
>...

cu
Adrian

BTW: I'm currently trying without success to understand why the
     drivers/infiniband/{hw/amso1100,ulp/srp}/Kbuild files are not
     named "Makefile".

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

