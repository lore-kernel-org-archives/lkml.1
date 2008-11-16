Return-Path: <linux-kernel-owner+w=401wt.eu-S1754176AbYKPRz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176AbYKPRz2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 12:55:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751969AbYKPRzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 12:55:20 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:40743 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751903AbYKPRzT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 12:55:19 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: =?utf-8?q?J=C3=B6rn_Engel?= <joern@logfs.org>
Subject: Re: [PATCH] mtd: unify mtd partition/device registration
Date: Sun, 16 Nov 2008 12:55:17 -0500
User-Agent: KMail/1.10.3 (Linux/2.6.27.4; KDE/4.1.3; x86_64; ; )
Cc: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
       linux-kernel@vger.kernel.org
References: <1226533133-7405-1-git-send-email-vapier@gentoo.org> <20081116173453.GA703@logfs.org>
In-Reply-To: <20081116173453.GA703@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200811161255.18513.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 16 November 2008 12:34:54 Jörn Engel wrote:
> On Wed, 12 November 2008 18:38:53 -0500, Mike Frysinger wrote:
> > Rather than having every map/mtd driver doing the same sequence of
> > registering partitions and/or devices, implement common parse_mtd().
>
> I just added partitioning support to block2mtd.  Looks like I might
> rethink the patch. :)
>
> > @@ -292,6 +292,43 @@ void put_mtd_device(struct mtd_info *mtd)
> >  	module_put(mtd->owner);
> >  }
> >
> > +#include <linux/mtd/partitions.h>
>
> #include in the middle of the code?

maybe i'll stick a comment above it ... the reason was to be proactive in 
preventing mtd partitioning code bleeding into the core.  maybe i'm just 
paranoid.
-mike
