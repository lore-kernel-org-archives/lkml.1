Return-Path: <linux-kernel-owner+w=401wt.eu-S1751406AbXBVCec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751406AbXBVCec (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 21:34:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751410AbXBVCec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 21:34:32 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:37614 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406AbXBVCeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 21:34:31 -0500
Date: Wed, 21 Feb 2007 21:33:09 -0500
Message-Id: <200702220233.l1M2X9fl010426@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, unionfs@filesystems.org,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: [Unionfs] Re: [-mm patch] UNION_FS must depend on SLAB 
In-reply-to: Your message of "Wed, 21 Feb 2007 21:00:39 EST."
             <20070222020036.GE5867@filer.fsl.cs.sunysb.edu> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

For what it's worth, the new branch-management code also needs realloc():
right now I do a kfree/kalloc instead.  So I'm all for having a true
krealloc function.

Erez.
