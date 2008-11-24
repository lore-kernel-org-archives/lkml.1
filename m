Return-Path: <linux-kernel-owner+w=401wt.eu-S1752627AbYKXKdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627AbYKXKdU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 05:33:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750855AbYKXKdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 05:33:11 -0500
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:25973 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750806AbYKXKdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 05:33:10 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       Jim Radford <radford@galvanix.net>
In-Reply-To: <20081122231631.GA6456@uranus.ravnborg.org>
References: <20081122231631.GA6456@uranus.ravnborg.org>
Content-Type: text/plain
Date: Mon, 24 Nov 2008 10:31:08 +0000
Message-Id: <1227522668.9425.21.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.200.22.2
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [RFC PATCH] kbuild: move tags support to a shell script
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.0 c=1 a=1JJopRNZEXkA:10 a=i2aGPtDiL5YA:10 a=pC_Hrc7NWn7NT4Jph7QA:9 a=9iW_30EiwJn4qZHaNF8A:7 a=GZvoSkQXEQmFG_p5Qe4xizR1bk8A:4 a=LY0hPdMaydYA:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-11-23 at 00:16 +0100, Sam Ravnborg wrote:
> As no-one else wanted to do so - I now moved the tags support
> to a shell script of its own.
> The usage is the same: make {tags,TAGS,cscope}
> 
> The ALLSOURCE_ARCHS suppport was lost in the transition - is it actually used by anyone?

I'm the one who actually added it way back in
a0674e88d9c150e016a69e78e735f48772314c53 and to be honest I don't use it
anymore since I've changed jobs and only really do x86 now...

I can't say if anyone else is using it though.

> I have given the patch only some light testing.
> 
> Could those of you that actually sues tags/cscope plese give it a try.

I tested your second patch from the subsequent email and functionally it
seems fine, it currently includes include/asm-* for all architectures
but I suppose they will all go away shortly.

The output was a bit odd though:
        $ make cscope
        /bin/sh /local/scratch/ianc/devel/linux-2.6.git/scripts/tags.sh cscope
          GEN     cscope.out (from 13251 files)
I guess I would have expected "  GEN     cscope.files" instead of the
first line or just "  TAGS"?

Ian.
-- 
Ian Campbell
Current Noise: Nine Inch Nails - Where Is Everybody?

"We came.  We saw.  We kicked its ass."
		-- Bill Murray, _Ghostbusters_

