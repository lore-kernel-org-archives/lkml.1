Return-Path: <linux-kernel-owner+w=401wt.eu-S1761936AbXF1KrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761936AbXF1KrR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 06:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755893AbXF1KrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 06:47:10 -0400
Received: from mailgw10.fraunhofer.de ([153.96.1.22]:44561 "EHLO
	mailgw10.fraunhofer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755500AbXF1KrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 06:47:09 -0400
Date: Thu, 28 Jun 2007 12:44:39 +0200
From: Joerg.Schilling@fokus.fraunhofer.de (Joerg Schilling)
To: harald@skogtun.org, bunk@stusta.de
Cc: mrmacman_g4@mac.com, linux-kernel@vger.kernel.org, dwmw2@infradead.org,
       david@lang.hm
Subject: Re: Userspace compiler support of "long long"
Message-ID: <46839117.mA0o/4bJHyS7q5w0%Joerg.Schilling@fokus.fraunhofer.de>
References: <467afc63.OnsqEXOk5zqMYzym%Joerg.Schilling@fokus.fraunhofer.de>
 <Pine.LNX.4.64.0706211620080.31603@asgard.lang.hm>
 <467b0bf2.Xfs7T8Ys4nY9ZNLW%Joerg.Schilling@fokus.fraunhofer.de>
 <1182483527.10524.31.camel@shinybook.infradead.org>
 <20070622150038.GN23017@stusta.de>
 <E27BAC4D-2F1E-4191-A75D-4DD18231C320@mac.com>
 <20070627154046.GN1094@stusta.de>
 <468287a8.spBb6PdAZ4QV0j2Y%Joerg.Schilling@fokus.fraunhofer.de>
 <20070627173240.GR1094@stusta.de>
 <87ejjwgytd.fsf@basilikum.skogtun.org>
In-Reply-To: <87ejjwgytd.fsf@basilikum.skogtun.org>
User-Agent: nail 11.22 3/20/05
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO8859-1
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 28 Jun 2007 10:46:38.0153 (UTC) FILETIME=[9AB7D390:01C7B971]
X-Fraunhofer-Email-Policy: accepted
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Harald Arnesen <harald@skogtun.org> wrote:

> Adrian Bunk <bunk@stusta.de> writes:
>
> > Is there any userspace Linux compiler that does not support "long long"?
> > If yes, is there any other way to tell that something is a
> > 64bit int on 32bit architectures?
>
> TenDRA C:
>
> "test.c", line 6: Error:
>   [ISO 6.5.2]: Illegal type specifier, 'long long', assuming 'long'.

You cannot use this compiler for any program that uses an interface that
needs long long.

BTW: C99 requires long long but the Large File summit from 1995 did to the
same since 1995. An 32 bit OS that supports large files cannot have a compiler
that does not support long long.

If TenDRA C does support 64 bit integral type in a different way. TenDRA C
would need to deliver include files that take care about this fact.

Jörg

-- 
 EMail:joerg@schily.isdn.cs.tu-berlin.de (home) Jörg Schilling D-13353 Berlin
       js@cs.tu-berlin.de                (uni)  
       schilling@fokus.fraunhofer.de     (work) Blog: http://schily.blogspot.com/
 URL:  http://cdrecord.berlios.de/old/private/ ftp://ftp.berlios.de/pub/schily
