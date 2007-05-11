Return-Path: <linux-kernel-owner+w=401wt.eu-S1763064AbXEKUxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763064AbXEKUxw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 16:53:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762967AbXEKUxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 16:53:31 -0400
Received: from fmmailgate05.web.de ([217.72.192.243]:43403 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762884AbXEKUxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 16:53:30 -0400
Date: Fri, 11 May 2007 22:48:15 +0200
Message-Id: <1783772957@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, nitingupta.mail@gmail.com
Subject: Re: [PATCH] Add LZO1X compression support to the kernel
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1+63ap6BlsH4l5DQKTrkmQ2eqLNN8NS77liwbZDbf0CKCHU+
 6jyBMbdtm4cHxAJVu0JpL4eHCmIsb46QhtZdINGfmdANyf7jaI=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>Why is this needed?  What code plans to use it?

it`s pretty useful because it`s and a damn fast and damn cpu friendly compression alorithm.

afaik, there is already a least one linux kernel-feature (under development) which is using lzo compression: 
see compressed caching project at http://linux-mm.org/CompressedCaching & http://linuxcompressed.sourceforge.net/

seems, they have also done porting it to the kernel, so there is probably choice between two implemetations to merge.

>How many buffer overruns are there in it?

i don`t know :) 
but, from a user-perspective,  lzo is really portable and seems to be a rock solid compression scheme.
i`m sucessfully using it for years (lzop utility) and i know projects which compress gigabytes of data every day with lzop.
furthermore, i know of at least 40 software projects using lzo compression, so this should have some level of maturity.

maybe i can add another software integrating lzo compression to the enumeration at http://www.lzop.de ? ;)

regards
roland


List:       linux-kernel
Subject:    Re: [PATCH] Add LZO1X compression support to the kernel
From:       Andrew Morton <akpm () linux-foundation ! org>
Date:       2007-05-10 6:21:29
Message-ID: 20070509232129.371f49d5.akpm () linux-foundation ! org
[Download message RAW]

On Wed, 02 May 2007 09:56:23 +0100 Richard Purdie <richard@openedhand.com> wrote:

> Current thinking is that lzo should get merged directly followed by the
> subsystem parts through their specific trees. It appears this should
> make it onto LKML despite the size so here goes.
> 
> Please keep in mind I haven't reformatted the LZO code itself as if I do
> so, it will make maintenance of it against any changes in LZO itself
> near impossible. In its current form, it should be possible to diff
> against upstream. All the bad formatting is confined to a handful of
> files in lib/lzo/ and the kernel interface should be clean.
> 
> I realise a maze of ifdefs still remain. I've already spent a lot of
> time removing a ton of them and going much further might start to affect
> diffability of the code - I hoping whats there is a good compromise.
> 
> I've asked the LZO author about the comments on lzo_copyright function
> but the code is GPLv2 licensed so is suitable for inclusion in the
> kernel.
> 
> 
> 
> Add LZO1X compression/decompression support to the kernel.
> 
> This is based on the standard userspace lzo library, particularly
> minilzo with the headers much trimmed down and simplified for kernel
> use. Its structured so that it should still diff with the userspace
> version for ease of future updating.

Well that's attractive-looking code.

Why is this needed?  What code plans to use it?

How many buffer overruns are there in it?
_____________________________________________________________________
Der WEB.DE SmartSurfer hilft bis zu 70% Ihrer Onlinekosten zu sparen!
http://smartsurfer.web.de/?mc=100071&distributionid=000000000066

