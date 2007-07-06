Return-Path: <linux-kernel-owner+w=401wt.eu-S1763141AbXGFPA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763141AbXGFPA4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 11:00:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755250AbXGFPAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 11:00:49 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:61596 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203AbXGFPAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 11:00:48 -0400
Date: Fri, 6 Jul 2007 17:00:40 +0200 (CEST)
From: Bodo Eggert <7eggert@gmx.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Bodo Eggert <7eggert@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][Patch] Allow not mounting a root fs
In-Reply-To: <468DA42D.7050309@zytor.com>
Message-ID: <Pine.LNX.4.58.0707061551240.2241@be1.lrz>
References: <Pine.LNX.4.58.0707060318160.26869@be1.lrz> <468DA42D.7050309@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1/3qHRJfiP+4y8Hqb2SVLmbycENdseJxSMytS9
 4KnakuoJOY/zaM7gaC8LL2Djd4oD4yfT3RtAOCaINbMwipn1fT
 MnSz97qYJCw1sqrVJZpOg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jul 2007, H. Peter Anvin wrote:

> Bodo Eggert wrote:
> > This patch adds the option to not mount another root filesystem 
> > by specifying root=initramfs.
> 
> Uhm, the kernel doesn't mount anything if you're using an initramfs.

Yes, instead it panics trying to mount the non-existing "root=".
I've put the complete system into initrams, and I just want the kernel to
run /sbin/init.

> > BTW: Is it possible to mount a tmpfs on / before extracting the cpio?
> 
> Not in the stock kernel.  There have been some patches floating around
> for that, I think.

Are they messy, or would it just be a case of calling sys_mount before 
unpacking the cpio?
-- 
The complexity of a weapon is inversely proportional to the IQ of the
weapon's operator.
