Return-Path: <linux-kernel-owner+w=401wt.eu-S933955AbXEOJXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933955AbXEOJXh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 05:23:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759645AbXEOJXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 05:23:30 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:45900 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759471AbXEOJX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 05:23:29 -0400
X-Originating-Ip: 72.143.66.196
Date: Tue, 15 May 2007 05:22:51 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Heikki Orsila <shdl@zakalwe.fi>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: On __pure and __attribute_pure__
In-Reply-To: <20070515091246.GE10873@zakalwe.fi>
Message-ID: <Pine.LNX.4.64.0705150521020.20664@localhost.localdomain>
References: <20070515091246.GE10873@zakalwe.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 May 2007, Heikki Orsila wrote:

> Both __pure and __attribute_pure__ are the same, and I found out that
> there is only a handful of users for these. __attribute_pure__ is
> used in approximately 15 places, and __pure is not used anywhere.
>
> Is either __pure or __attribute_pure__ preferred? Imo, __pure looks
> much nicer than __attribute_pure__ so we could do a replacement.

that was pretty much the point of my earlier post -- given the
precedent for all of the other short forms, there seems to be no
reason not to simply use "__pure" and delete the longer definition.

i'll post a patch for that shortly.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
