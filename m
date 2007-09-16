Return-Path: <linux-kernel-owner+w=401wt.eu-S1753249AbXIPNAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249AbXIPNAR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 09:00:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751731AbXIPNAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 09:00:05 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:60559 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbXIPNAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 09:00:04 -0400
X-Originating-Ip: 72.143.66.27
Date: Sun, 16 Sep 2007 08:58:03 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Sam Ravnborg <sam@ravnborg.org>
cc: kbuild devel <kbuild-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: kbuild update
In-Reply-To: <20070916094739.GA6672@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.64.0709160856060.20489@localhost.localdomain>
References: <20070916094739.GA6672@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.723, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00, RCVD_IN_SORBS_DUL 20.00,
	TW_VN 0.08)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Sep 2007, Sam Ravnborg wrote:

> A summary of what is planned to be submitted in next merge window for kbuild.
> The shortlog below have additional details but the headlines are:
...
> o add script to find unused kconfig symbols (try it!)

based on my experiences with this, unless you filter carefully, you're
going to end up with a *whack* of false positives given the number of
developers who elect to name their local macros starting with a prefix
of "CONFIG_".  good luck dealing with *that*.  :-)

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
