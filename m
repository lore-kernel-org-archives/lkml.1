Return-Path: <linux-kernel-owner+w=401wt.eu-S1755163AbXFYMcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163AbXFYMcT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 08:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752885AbXFYMcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 08:32:04 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:57015 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614AbXFYMcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 08:32:01 -0400
X-Originating-Ip: 74.102.207.204
Date: Mon, 25 Jun 2007 08:27:42 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Johannes Weiner <hannes-kernel@saeurebad.de>
cc: vignesh babu <vignesh.babu@wipro.com>, daniel.pirkl@email.cz,
       dushistov@mail.ru, linux-kernel <linux-kernel@vger.kernel.org>,
       Kernel Janitors List <kernel-janitors@lists.osdl.org>
Subject: Re: [PATCH]is_power_of_2-ufs/super.c
In-Reply-To: <20070625121316.GA19544@saeurebad.de>
Message-ID: <Pine.LNX.4.64.0706250826300.4499@localhost.localdomain>
References: <1181808559.2474.9.camel@merlin.linuxcoe.com>
 <20070625121316.GA19544@saeurebad.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jun 2007, Johannes Weiner wrote:

> Hi,
>
> On Thu, Jun 14, 2007 at 01:39:18PM +0530, vignesh babu wrote:
> > Replacing (n & (n-1)) in the context of power of 2 checks
> > with is_power_of_2
>
> You might want to run
>
> 	egrep -R '([a-zA-Z0-9_.>]+) *& *\(\1 *- *1\)' /usr/src/linux
>
> This does not match if the check is broken into multiple lines,
> though. Still, 66 matches so far. Perhaps a big patch that removes
> most of these occurrences would be more appropriate.

this cleanup project is already well documented here:

http://fsdev.net/wiki/index.php?title=Power_of_2_stuff

and it's unlikely that you'd get a big patch in that tries to do all
of that at once.  it's much easier to do it a subsystem at a time.

rday

p.s.  that wiki page could probably use some updating.

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
