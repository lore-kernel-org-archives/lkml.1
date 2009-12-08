Return-Path: <linux-kernel-owner+w=401wt.eu-S965766AbZLHSBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965766AbZLHSBY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 13:01:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965755AbZLHSBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 13:01:19 -0500
Received: from lon1-post-3.mail.demon.net ([195.173.77.150]:56240 "EHLO
	lon1-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965752AbZLHSBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 13:01:18 -0500
Message-ID: <4B1E93E5.8090104@lougher.demon.co.uk>
Date: Tue, 08 Dec 2009 17:59:01 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Peter Korsgaard <jacmet@sunsite.dk>
CC: linux-embedded@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, phillip.lougher@gmail.com,
       tim.bird@am.sony.com
Subject: Re: [PATCH 0/9] Squashfs: Add support for LZMA compressed filesystems
References: <E1NHYun-000287-Vq@dylan.lougher.demon.co.uk> <87tyw3p3vu.fsf@macbook.be.48ers.dk>
In-Reply-To: <87tyw3p3vu.fsf@macbook.be.48ers.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Korsgaard wrote:
>>>>>> "root" == root  <root@lougher.demon.co.uk> writes:
> 
>  root> Hi,
>  root> The following patches add LZMA decompression support to Squashfs, using the
>  root> in-kernel LZMA decompression library.
> 
>  root> The patches also add a decompression framework to Squashfs.
>  root> This allows LZMA decompression to be added cleanly, and it allows
>  root> additional decompressors to be easily added in the future.
> 
>  root> To enable the in-kernel LZMA decompression code to be used by Squashfs,
>  root> there are two patches to the lzma code itself: one to make lzma available
>  root> to non-init code, and one to make lzma reentrant.  These are obviously
>  root> not restricted to Squashfs, but are needed by any non-init code that
>  root> may wish to use lzma compression.
> 
> Nice, do you also have an mksquashfs with lzma support?
> 

Yes, in Squashfs CVS (http://sourceforge.net/projects/squashfs/develop).
You'll need to edit the squashfs-tools Makefile to enable LZMA support.
The comments in the Makefile should, hopefully, explain how to
build LZMA support into Mksquashfs/Unsquashfs.

Once built-in, LZMA support can be specified using the -comp lzma option, i.e.

mksquashfs dir dir.img -comp lzma

Unsquashfs doesn't need any extra options, it automatically detects which
compression has been used.

You can tell which compression algorithms Mksquashfs/Unsquashfs support by
just typing the command on its own (i.e. mksquashfs, or unsquashfs).  The
(de-)compressors available are displayed at the end of the output.

Phillip






