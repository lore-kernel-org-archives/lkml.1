Return-Path: <linux-kernel-owner+w=401wt.eu-S1754897AbXE3Nzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897AbXE3Nzl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 09:55:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752663AbXE3Nze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 09:55:34 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:55714 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752003AbXE3Nzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 09:55:33 -0400
Date: Wed, 30 May 2007 16:55:30 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Sam Ravnborg <sam@ravnborg.org>
cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: ppc modprost warnings in 2.6.22-rc1
In-Reply-To: <20070515204540.GC22966@uranus.ravnborg.org>
Message-ID: <Pine.SOC.4.64.0705301652250.23769@math>
References: <Pine.SOC.4.64.0705141717110.23895@math> <20070515204540.GC22966@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > WARNING: arch/ppc/platforms/built-in.o - Section mismatch: reference to .init.text:Powerplus_Map_Non0 from .data between 'mot_info' (at offset 0x18) and 'Mesquite_pci_IRQ_map'
> .....
> 
> mot_info is only used by functions marked __init.
> So why not mark it __init so it get discarded and we get rid of all those warnings?

How do I mark a initialized struct __init? Adding __init or const __init in
front of the declaration results in

  CC      arch/ppc/platforms/prep_pci.o
arch/ppc/platforms/prep_pci.c:806: error: mot_info causes a section type conflict

-- 
Meelis Roos (mroos@linux.ee)
