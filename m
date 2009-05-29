Return-Path: <linux-kernel-owner+w=401wt.eu-S1760877AbZE2PNN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760877AbZE2PNN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 11:13:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759542AbZE2PM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 11:12:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:57562 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759304AbZE2PMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 11:12:55 -0400
Subject: Re: [PATCH 3/4] [MTD] compat_ioctl cleanup
From: David Woodhouse <dwmw2@infradead.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Kevin Cernekee <kpc.mtd@gmail.com>,
       Adrian Hunter <adrian.hunter@nokia.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Linux MTD <linux-mtd@lists.infradead.org>
In-Reply-To: <1243609469.19886.180.camel@macbook.infradead.org>
References: <a95a62fe0904082253i119f8660y6a73835a163394f5@mail.gmail.com>
	 <200904141643.48345.arnd@arndb.de>
	 <1243609469.19886.180.camel@macbook.infradead.org>
Content-Type: text/plain
Date: Fri, 29 May 2009 16:12:52 +0100
Message-Id: <1243609972.19886.182.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 (2.26.1-2.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-29 at 16:04 +0100, David Woodhouse wrote:
> On Tue, 2009-04-14 at 16:43 +0200, Arnd Bergmann wrote:
> > This looks correct, but I think it would be better to just remove all
> > those lines from fs/compat_ioctl.c and add a default: statement in
> > mtd_compat_ioctl that calls mtd_ioctl for all ioctl numbers that
> > don't have an explicit handler.
> 
> He did that already; I've just committed it to my local tree and will be
> pushing it out as soon as I fix the compat_ptr() thing.

Pushed to git.infradead.org/mtd-2.6.git

Thanks, Kevin.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

