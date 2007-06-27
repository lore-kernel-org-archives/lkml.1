Return-Path: <linux-kernel-owner+w=401wt.eu-S1762583AbXF0Qo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762583AbXF0Qo6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 12:44:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757708AbXF0Qoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 12:44:39 -0400
Received: from mailgw1.fraunhofer.de ([153.96.1.18]:63914 "EHLO
	mailgw1.fraunhofer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130AbXF0Qof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 12:44:35 -0400
Date: Wed, 27 Jun 2007 18:41:17 +0200
From: Joerg.Schilling@fokus.fraunhofer.de (Joerg Schilling)
To: bunk@stusta.de
Cc: schilling@fokus.fraunhofer.de, sam@ravnborg.org,
       linux-kernel@vger.kernel.org, arjan@infradead.org
Subject: Re: Linux Kernel include files
Message-ID: <4682932d.pVHCxteMR+otOnHO%Joerg.Schilling@fokus.fraunhofer.de>
References: <46826d13.44vmeDzVCWEJhtNJ%Joerg.Schilling@fokus.fraunhofer.de>
 <20070627164012.GQ1094@stusta.de>
In-Reply-To: <20070627164012.GQ1094@stusta.de>
User-Agent: nail 11.22 3/20/05
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO8859-1
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 27 Jun 2007 16:43:15.0298 (UTC) FILETIME=[41FF4C20:01C7B8DA]
X-Fraunhofer-Email-Policy: accepted
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk <bunk@stusta.de> wrote:

> > On Suse Linux 10.0, I get e.g.:
> > 
> > cat t.c
> > #include <stdio.h>
> > #include <linux/ext2_fs.h>
> > 
> > gcc -c t.c
> > In file included from /usr/include/linux/ext2_fs.h:20,
> >                  from t.c:2:
> > /usr/include/linux/ext2_fs_sb.h:40: error: syntax error before âuid_tâ
> > /usr/include/linux/ext2_fs_sb.h:49: error: syntax error before âs_next_generationâ
> > /usr/include/linux/ext2_fs_sb.h:51: error: syntax error before â*â token
> > /usr/include/linux/ext2_fs_sb.h:56: error: syntax error before â}â token
>
> Already fixed since kernel 2.6.18.
>
> Our header were a mess and we are working on getting them better.
> But we can't timetravel and fix old distributions.

Well, I did report these kind of problems many years ago and as it has not been 
fixed after some years, I was asuming that it is still the way I see it on Suse 
10.0.



J�rg

-- 
 EMail:joerg@schily.isdn.cs.tu-berlin.de (home) J�rg Schilling D-13353 Berlin
       js@cs.tu-berlin.de                (uni)  
       schilling@fokus.fraunhofer.de     (work) Blog: http://schily.blogspot.com/
 URL:  http://cdrecord.berlios.de/old/private/ ftp://ftp.berlios.de/pub/schily
