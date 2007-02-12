Return-Path: <linux-kernel-owner+w=401wt.eu-S965324AbXBLTSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965324AbXBLTSz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 14:18:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965327AbXBLTSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 14:18:55 -0500
Received: from one.firstfloor.org ([213.235.205.2]:34059 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965324AbXBLTSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 14:18:54 -0500
X-Greylist: delayed 1925 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Feb 2007 14:18:54 EST
From: Andi Kleen <andi@firstfloor.org>
To: =?utf-8?q?J=C3=B6rn_Engel?= <joern@lazybastard.org>
Subject: Re: [PATCH x86 for review III] [10/29] i386: don't include bugs.h
Date: Mon, 12 Feb 2007 19:33:06 +0100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@osdl.org>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
References: <20070212551.664370000@suse.de> <20070212165130.450D413FCB@wotan.suse.de> <20070212173523.GB2112@lazybastard.org>
In-Reply-To: <20070212173523.GB2112@lazybastard.org>
Organization: -
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702121933.06431.andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > Index: linux/arch/i386/kernel/alternative.c
> > ===================================================================
> > --- linux.orig/arch/i386/kernel/alternative.c
> > +++ linux/arch/i386/kernel/alternative.c
> > @@ -4,7 +4,6 @@
> >  #include <linux/list.h>
> >  #include <asm/alternative.h>
> >  #include <asm/sections.h>
> > -#include <asm/bugs.h>
> >  
> >  static int no_replacement    = 0;
> >  static int smp_alt_once      = 0;
> 
> Didn't your patchset also include a near-identical patch from Adrian
> Bunk (with - and + exchanged)?

Good catch. I will remove both patches.

-Andi
