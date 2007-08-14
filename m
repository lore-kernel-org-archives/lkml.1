Return-Path: <linux-kernel-owner+w=401wt.eu-S1759777AbXHNCJH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759777AbXHNCJH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 22:09:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764676AbXHNCIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 22:08:13 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:48849 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764623AbXHNCIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 22:08:11 -0400
Message-ID: <46C10D9D.2090308@gmail.com>
Date: Tue, 14 Aug 2007 04:04:13 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Joe Perches <joe@perches.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] [1/2many] - FInd the maintainer(s) for a patch -	scripts/get_maintainer.pl
References: <1186984174.10249.7.camel@localhost>	 <200708131933.10125.m.kozlowski@tuxland.pl>	 <1187026955.2688.4.camel@laptopd505.fenrus.org>	 <1187037445.6628.98.camel@heimdal.trondhjem.org> <1187054366.2757.0.camel@laptopd505.fenrus.org> <46C10AA8.3090505@gmail.com>
In-Reply-To: <46C10AA8.3090505@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2007 03:51 AM, Rene Herman wrote:

> MODULE_MAINTAINER() was discussed a while ago but embedding information 
> into the binary has the problem you can't ever change deployed systems, 
> meaning it lags by design. If a maintainer changes, people would still 
> be using the information from their old binaries, meaning a replaced 
> maintainer might get contacted for potentially years still (and the new 
> one not).
> 
> (you could avoid that by placing not a name/address in the maintainer 
> tag but a pointer to somewhere else but at that point this gets to be 
> about solving something else).
> 
> Keeping it in the source alone is fine. C files could just embed their 
> MAINTAINERS entry as a header:
> 
> /*
>  * P: Maintainer
>  * M: Mail patches to
>  * L: Mailing list that is relevant to this area
>  * W: Web-page with status/info
>  * T: SCM tree type and location.  Type is one of: git, hg, quilt.
>  * S: Status, one of the following:
>  */
> 
> And probably adding fields:
> 
>  * I: Info/Summary (for index files and the like)
>  * A: Author
>  * G: License
> 
> and such. Yes, while we're at it, we can pick better letters or full 
> word tags ;-)

Okay, and if a single "maintenance unit" consists of many files, this gets 
to be too much yes. But they _could_ just grow a header pointing back to the 
MINTAINERS file/database;

/*
  * MAINTAINERS: 3C359 NETWORK DRIVER
  */

Thst should keep things minimal enough to keep them updated, no?

Rene.
