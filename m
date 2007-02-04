Return-Path: <linux-kernel-owner+w=401wt.eu-S1752392AbXBDPp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392AbXBDPp7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 10:45:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752398AbXBDPp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 10:45:59 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:41585 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbXBDPp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 10:45:58 -0500
Subject: Re: mm: how to check for kernel pages
From: Arjan van de Ven <arjan@infradead.org>
To: Michal Hocko <mstsxfx@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070204153321.GC10477@curandero.marconia.cz>
References: <20070204110256.GA10477@curandero.marconia.cz>
	 <1170597450.3073.1127.camel@laptopd505.fenrus.org>
	 <20070204153321.GC10477@curandero.marconia.cz>
Content-Type: text/plain
Organization: Intel International BV
Date: Sun, 04 Feb 2007 16:45:51 +0100
Message-Id: <1170603951.3073.1160.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-2.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-02-04 at 16:33 +0100, Michal Hocko wrote:
> On Sun, Feb 04, 2007 at 02:57:30PM +0100, Arjan van de Ven wrote:
> > On Sun, 2007-02-04 at 12:02 +0100, Michal Hocko wrote:
> > > Hi,
> > > is there any effective and fast way how to find out whether page
> > > given by its page frame number is currenly used by (mapped by) kernel?
> > 
> > what do you want to use this for? The answer to your question greatly
> > depends on that...
> 
> Sorry for not being more precise. As a part of my thesis work I need to
> migrate pages. I greatly use mm/migrate.c code.  
> I assume that not all pages can be migrated - especially those used by
> kernel (where direct virtual to physical mapping is used).
> So I intended something like following code:

it's more than that... even userspace pages may not be moved if they're
the target of active DMA for example ..... 
-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

