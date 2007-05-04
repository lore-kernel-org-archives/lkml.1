Return-Path: <linux-kernel-owner+w=401wt.eu-S1755041AbXEDMmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041AbXEDMmj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 08:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755042AbXEDMmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 08:42:39 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:52982 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755021AbXEDMmi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 08:42:38 -0400
Date: Fri, 4 May 2007 14:41:46 +0200
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Richard Purdie <rpurdie@openedhand.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Satyam Sharma <satyam.sharma@gmail.com>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] jffs2: Add LZO compression support to jffs2
Message-ID: <20070504144146.6a91d974@dhcp-252-105.norway.atmel.com>
In-Reply-To: <1178278532.11120.274.camel@pmac.infradead.org>
References: <1178278255.5839.47.camel@localhost.localdomain>
	<1178278532.11120.274.camel@pmac.infradead.org>
Organization: Atmel Norway
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 04 May 2007 12:35:32 +0100
David Woodhouse <dwmw2@infradead.org> wrote:

> On Fri, 2007-05-04 at 12:30 +0100, Richard Purdie wrote:
> > +config JFFS2_LZO
> > +       bool "JFFS2 LZO compression support" if JFFS2_COMPRESSION_OPTIONS
> > +       select LZO   
> 
> Please make it _depend_ on LZO instead. If you do that, I can merge the
> JFFS2 bits in anticipation of the core LZO code going upstream.

Hmm...everything else in lib/Kconfig is supposed to be _selected_, not
depended upon. And the only three items in there which can actually be
selected by the user all begin their helptexts with

"This option is provided for the case where no in-kernel-tree modules
require FOO functions".

Are you sure it's a good idea to break with existing practice? I'm
concerned that nobody will ever find the JFFS2_LZO option if it means
they will have to go all the way down to the "Library functions" menu
and select something to make the option visible...

Haavard
