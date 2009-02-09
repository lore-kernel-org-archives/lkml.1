Return-Path: <linux-kernel-owner+w=401wt.eu-S1756250AbZBISPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250AbZBISPw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 13:15:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753694AbZBISPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 13:15:41 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:43886 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306AbZBISPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 13:15:40 -0500
Date: Mon, 9 Feb 2009 18:14:33 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
cc: jgarzik@pobox.com, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk, rjw@sisk.pl
Subject: Re: [PATCH] libata-sff: fix 32-bit PIO regression
In-Reply-To: <49905E70.8000209@ru.mvista.com>
Message-ID: <Pine.LNX.4.64.0902091807580.31519@blonde.anvils>
References: <200902082253.07438.sshtylyov@ru.mvista.com>
 <Pine.LNX.4.64.0902082108290.18661@blonde.anvils> <498F73A5.2070300@ru.mvista.com>
 <Pine.LNX.4.64.0902091016520.14410@blonde.anvils> <49905D08.4050302@ru.mvista.com>
 <49905E70.8000209@ru.mvista.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Feb 2009, Sergei Shtylyov wrote:
> Hello, I wrote:
> 
> > > When I checked (mounting and listing a CD), about 34% of
> > > commands had slop 2.
> 
> >    Hm, that probably involved the raw block reads. I don't remember the raw
> > sector length off-hand but it may well be just even, not divisble by 4.
> 
>    Oops, I read "listening" instead of "listing". :-/
>    But I thought that listing shouldn't involve anything other than block 
> reads. OTOH, I'm not familiar enough with ISO9660... What commands are you
> seeing (if you have them dumped)?

No, I didn't dump out the commands, just added temporary slop stats
into the xfer32 function, to check what paths were being tested.

That machine is busy running tests now: I could try again when it's
done, what would you recommend for dumping out the commands (remember,
I'm not an ATA developer)?

Though, to be honest, I'd prefer to just let this unlikely subject drop!

Hugh
