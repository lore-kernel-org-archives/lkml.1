Return-Path: <linux-kernel-owner+w=401wt.eu-S1752434AbXBDQdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434AbXBDQdj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 11:33:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752439AbXBDQdj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 11:33:39 -0500
Received: from delta.idt.cz ([81.0.223.58]:1708 "EHLO delta.idt.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752434AbXBDQdi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 11:33:38 -0500
Date: Sun, 4 Feb 2007 17:54:08 +0100
From: Michal Hocko <mstsxfx@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: mm: how to check for kernel pages
Message-ID: <20070204165407.GD10477@curandero.marconia.cz>
References: <20070204110256.GA10477@curandero.marconia.cz> <1170597450.3073.1127.camel@laptopd505.fenrus.org> <20070204153321.GC10477@curandero.marconia.cz> <1170603951.3073.1160.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1170603951.3073.1160.camel@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 04, 2007 at 04:45:51PM +0100, Arjan van de Ven wrote:
> > Sorry for not being more precise. As a part of my thesis work I need to
> > migrate pages. I greatly use mm/migrate.c code.  
> > I assume that not all pages can be migrated - especially those used by
> > kernel (where direct virtual to physical mapping is used).
> > So I intended something like following code:
> 
> it's more than that... even userspace pages may not be moved if they're
> the target of active DMA for example ..... 

Ok, so what everything should be checked?

- PageReserved
- PageSlab
- PageLocked
- PageBuddy 
- PageCompound
- PageNosave
- PageNosaveFree 
- kernel page
- userspace active DMA as you've mentioned. But I don't know how to test
  it

-- 
Michal Hocko

