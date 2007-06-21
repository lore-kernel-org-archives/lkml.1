Return-Path: <linux-kernel-owner+w=401wt.eu-S1753491AbXFUXki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491AbXFUXki (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 19:40:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751015AbXFUXkb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 19:40:31 -0400
Received: from mailhub.fokus.fraunhofer.de ([193.174.154.14]:48016 "EHLO
	mailhub.fokus.fraunhofer.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750936AbXFUXka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 19:40:30 -0400
Date: Fri, 22 Jun 2007 01:38:26 +0200
From: Joerg.Schilling@fokus.fraunhofer.de (Joerg Schilling)
To: david@lang.hm
Cc: schilling@fokus.fraunhofer.de, linux-kernel@vger.kernel.org
Subject: Re: Linux Kernel include files
Message-ID: <467b0bf2.Xfs7T8Ys4nY9ZNLW%Joerg.Schilling@fokus.fraunhofer.de>
References: <467afc63.OnsqEXOk5zqMYzym%Joerg.Schilling@fokus.fraunhofer.de>
 <Pine.LNX.4.64.0706211620080.31603@asgard.lang.hm>
In-Reply-To: <Pine.LNX.4.64.0706211620080.31603@asgard.lang.hm>
User-Agent: nail 11.22 3/20/05
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm wrote:

> On Fri, 22 Jun 2007, Joerg Schilling wrote:
>
> > Is there some hope that at least the Linux kernel interface definition files and
> > everything recursively included from these files will be rewritten in vanilla
> > ANSI C?
>
> this has been discussed many times and the answer is that the kernel is 
> not gong to change it's side of things to ANSI C.
>
> that doesn't mean that one of the many projects out there to create 
> seperate interface headers won't do this.

The main problems are not really hard to fix......

-	Most problems eem to be related to the fact that Linux does not
	use C-99 based types in the kernel and the related type definitions 
	are not written in plain C. This is something that should be fixed
	with a source consolidation program or by defining aliases to 
	C-99 types in case the compiler is not GCC.

-	Other problems are caused by additional tag definitions that could
	be disabled in case of a non-GCC compile.

Jörg

-- 
 EMail:joerg@schily.isdn.cs.tu-berlin.de (home) Jörg Schilling D-13353 Berlin
       js@cs.tu-berlin.de                (uni)  
       schilling@fokus.fraunhofer.de     (work) Blog: http://schily.blogspot.com/
 URL:  http://cdrecord.berlios.de/old/private/ ftp://ftp.berlios.de/pub/schily
