Return-Path: <linux-kernel-owner+w=401wt.eu-S1756633AbXKFVOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756633AbXKFVOZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 16:14:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754331AbXKFVOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 16:14:17 -0500
Received: from [212.12.190.217] ([212.12.190.217]:54572 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754233AbXKFVOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 16:14:17 -0500
From: Al Boldi <a1426z@gawab.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] init: Introduce rootdir bootparm to select which dir to sys_chroot
Date: Thu, 8 Nov 2007 00:13:20 +0300
User-Agent: KMail/1.5
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <200711061340.26112.a1426z@gawab.com> <200711072310.20715.a1426z@gawab.com> <4730CAD8.1050407@zytor.com>
In-Reply-To: <4730CAD8.1050407@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711080013.20702.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Al Boldi wrote:
> > Al Boldi wrote:
> >> This patch introduces a rootdir kernel boot parameter, which specifies
> >> the path to the kernel sys_chroot boot dir.
> >>
> >> This is useful for systems that have more than one distribution
> >> installed on the same fs/partition.
>
> This seems like something that should be done via an initramfs.

Agreed. But, not everybody boots their systems via initramfs, and even if 
they did, they also have to know how to reconfigure it.

In contrast, this patch offers the rootdir functionality as a simple bootparm 
and without any extra initramfs dependency.


Thanks!

--
Al


