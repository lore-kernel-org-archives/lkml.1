Return-Path: <linux-kernel-owner+w=401wt.eu-S1762289AbXF0Py7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762289AbXF0Py7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 11:54:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754750AbXF0Pyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 11:54:50 -0400
Received: from mailgw10.fraunhofer.de ([153.96.1.22]:46063 "EHLO
	mailgw10.fraunhofer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758428AbXF0Pyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 11:54:49 -0400
Date: Wed, 27 Jun 2007 17:52:08 +0200
From: Joerg.Schilling@fokus.fraunhofer.de (Joerg Schilling)
To: mrmacman_g4@mac.com, bunk@stusta.de
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org, david@lang.hm
Subject: Re: Linux Kernel include files
Message-ID: <468287a8.spBb6PdAZ4QV0j2Y%Joerg.Schilling@fokus.fraunhofer.de>
References: <467afc63.OnsqEXOk5zqMYzym%Joerg.Schilling@fokus.fraunhofer.de>
 <Pine.LNX.4.64.0706211620080.31603@asgard.lang.hm>
 <467b0bf2.Xfs7T8Ys4nY9ZNLW%Joerg.Schilling@fokus.fraunhofer.de>
 <1182483527.10524.31.camel@shinybook.infradead.org>
 <20070622150038.GN23017@stusta.de>
 <E27BAC4D-2F1E-4191-A75D-4DD18231C320@mac.com>
 <20070627154046.GN1094@stusta.de>
In-Reply-To: <20070627154046.GN1094@stusta.de>
User-Agent: nail 11.22 3/20/05
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO8859-1
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 27 Jun 2007 15:54:06.0567 (UTC) FILETIME=[646AA770:01C7B8D3]
X-Fraunhofer-Email-Policy: accepted
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk <bunk@stusta.de> wrote:

> That's a good point I missed.
>
> What about:
>
> #if defined(__GNUC__) && __STDC_VERSION__ < 19901L
> __extension__ typedef   signed long long __s64;
> __extension__ typedef unsigned long long __u64;
> #else
> typedef   signed long long __s64;
> typedef unsigned long long __u64;
> #endif

What about using:

#if (defined(__GNUC__) || defined(__SUNPRO_C)) && !defined(__STRICT_ANSI__) 

Well, there seems to be one other compiler (the one from Intel).
It may be that if this compiler does not claim to be GCC, another
definituion needs to be added.

Jörg

-- 
 EMail:joerg@schily.isdn.cs.tu-berlin.de (home) Jörg Schilling D-13353 Berlin
       js@cs.tu-berlin.de                (uni)  
       schilling@fokus.fraunhofer.de     (work) Blog: http://schily.blogspot.com/
 URL:  http://cdrecord.berlios.de/old/private/ ftp://ftp.berlios.de/pub/schily
