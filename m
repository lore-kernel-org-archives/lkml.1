Return-Path: <linux-kernel-owner+w=401wt.eu-S1755101AbXEDMro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101AbXEDMro (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 08:47:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755117AbXEDMro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 08:47:44 -0400
Received: from canuck.infradead.org ([209.217.80.40]:60382 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755021AbXEDMrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 08:47:43 -0400
Subject: Re: [PATCH 2/5] jffs2: Add LZO compression support to jffs2
From: David Woodhouse <dwmw2@infradead.org>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Richard Purdie <rpurdie@openedhand.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Satyam Sharma <satyam.sharma@gmail.com>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20070504144146.6a91d974@dhcp-252-105.norway.atmel.com>
References: <1178278255.5839.47.camel@localhost.localdomain>
	 <1178278532.11120.274.camel@pmac.infradead.org>
	 <20070504144146.6a91d974@dhcp-252-105.norway.atmel.com>
Content-Type: text/plain
Date: Fri, 04 May 2007 13:47:32 +0100
Message-Id: <1178282852.11120.282.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7.dwmw2.2) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-05-04 at 14:41 +0200, Haavard Skinnemoen wrote:
> 
> Hmm...everything else in lib/Kconfig is supposed to be _selected_, not
> depended upon. And the only three items in there which can actually be
> selected by the user all begin their helptexts with
> 
> "This option is provided for the case where no in-kernel-tree modules
> require FOO functions".
> 
> Are you sure it's a good idea to break with existing practice? I'm
> concerned that nobody will ever find the JFFS2_LZO option if it means
> they will have to go all the way down to the "Library functions" menu
> and select something to make the option visible...

That would seem be a tools problem.

Nevertheless, if I merge it with 'select', won't it break while the core
LZO patches aren't yet upstream?

Of course, one could argue that that's also a tools problem. All this
proliferation of 'select' is doing is moving problems around rather than
solving them.

-- 
dwmw2

