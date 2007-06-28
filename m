Return-Path: <linux-kernel-owner+w=401wt.eu-S1762494AbXF1KtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762494AbXF1KtZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 06:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757726AbXF1KtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 06:49:18 -0400
Received: from mailgw1.fraunhofer.de ([153.96.1.18]:51763 "EHLO
	mailgw1.fraunhofer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757324AbXF1KtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 06:49:17 -0400
Date: Thu, 28 Jun 2007 12:47:13 +0200
From: Joerg.Schilling@fokus.fraunhofer.de (Joerg Schilling)
To: sam@ravnborg.org
Cc: schilling@fokus.fraunhofer.de, linux-kernel@vger.kernel.org,
       arjan@infradead.org
Subject: Re: Linux Kernel include files
Message-ID: <468391b1.FWbVqHFDqTyyQX6i%Joerg.Schilling@fokus.fraunhofer.de>
References: <46826d13.44vmeDzVCWEJhtNJ%Joerg.Schilling@fokus.fraunhofer.de>
 <20070627171812.GA31705@uranus.ravnborg.org>
In-Reply-To: <20070627171812.GA31705@uranus.ravnborg.org>
User-Agent: nail 11.22 3/20/05
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO8859-1
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 28 Jun 2007 10:49:12.0157 (UTC) FILETIME=[F682F8D0:01C7B971]
X-Fraunhofer-Email-Policy: accepted
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg <sam@ravnborg.org> wrote:

> > gcc -c t.c
> > In file included from /usr/include/linux/ext2_fs.h:20,
> >                  from t.c:2:
> > /usr/include/linux/ext2_fs_sb.h:40: error: syntax error before âuid_tâ
> > /usr/include/linux/ext2_fs_sb.h:49: error: syntax error before âs_next_generationâ
> > /usr/include/linux/ext2_fs_sb.h:51: error: syntax error before â*â token
> > /usr/include/linux/ext2_fs_sb.h:56: error: syntax error before â}â token
>
> Hi Jörg.
>
> For my test I used latest -git of the Linux kernel.
> In this version the include of ext2_fs_bh.h is guarded
> by __KERNEL__ like this:
>
> #ifdef __KERNEL__
> #include <linux/ext2_fs_sb.h>
> static inline struct ext2_sb_info *EXT2_SB(struct super_block *sb)
> {
>         return sb->s_fs_info;
> }
>

Thank you!

Jörg

-- 
 EMail:joerg@schily.isdn.cs.tu-berlin.de (home) Jörg Schilling D-13353 Berlin
       js@cs.tu-berlin.de                (uni)  
       schilling@fokus.fraunhofer.de     (work) Blog: http://schily.blogspot.com/
 URL:  http://cdrecord.berlios.de/old/private/ ftp://ftp.berlios.de/pub/schily
