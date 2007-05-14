Return-Path: <linux-kernel-owner+w=401wt.eu-S1760126AbXENUll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760126AbXENUll (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 16:41:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756597AbXENUlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 16:41:31 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:54038 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755440AbXENUla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 16:41:30 -0400
Date: Mon, 14 May 2007 22:39:58 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Bharata B Rao <bharata@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Jan Blunck <j.blunck@tu-harburg.de>
Subject: Re: [RFC][PATCH  3/14] Add the whiteout file type
In-Reply-To: <20070514093943.GE4139@in.ibm.com>
Message-ID: <Pine.LNX.4.61.0705142239290.9570@yvahk01.tjqt.qr>
References: <20070514093722.GB4139@in.ibm.com> <20070514093943.GE4139@in.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 14 2007 15:09, Bharata B Rao wrote:
>
>A white-out stops the VFS from further lookups of the white-outs name and
>returns -ENOENT. This is the same behaviour as if the filename isn't
>found. This can be used in combination with union mounts to virtually
>delete (white-out) files by creating a file with this file type.
>
>Signed-off-by: Jan Blunck <j.blunck@tu-harburg.de>
>Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
>---
> include/linux/stat.h |    2 ++
> 1 files changed, 2 insertions(+)
>
>--- a/include/linux/stat.h
>+++ b/include/linux/stat.h
>@@ -10,6 +10,7 @@
> #if defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2)
> 
> #define S_IFMT  00170000
>+#define S_IFWHT  0160000	/* whiteout */
> #define S_IFSOCK 0140000
> #define S_IFLNK	 0120000
> #define S_IFREG  0100000

I wonder why 110000, 130000 or 150000 could not also be used?


	Jan
-- 
