Return-Path: <linux-kernel-owner+w=401wt.eu-S1758287AbZC0RF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758287AbZC0RF3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 13:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753213AbZC0RFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 13:05:11 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50859 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178AbZC0RFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 13:05:10 -0400
Date: Fri, 27 Mar 2009 13:05:05 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: liqin.chen@sunplusct.com
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH 10/13] score - New architecure port to SunplusCT S+CORE
	processor
Message-ID: <20090327170505.GB29999@bombadil.infradead.org>
References: <OF23D2A1D1.74CB7871-ON48257586.00098D8A-48257586.0009CE62@sunplusct.com> <200903271626.20863.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903271626.20863.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Liqin,

On Fri, Mar 27, 2009 at 04:26:20PM +0100, Arnd Bergmann wrote:
> <lots of good stuff here.>

It looks like virtually all of this port has been cribbed from MIPS, which is
possibly not the wisest move...

(Not that it's bad, or wrong, but simply because MIPS was one of the
first Linux ports, and has... compatibility constraints because of it
that new ports don't need to be compatible with.)

You may want to look at avr32 and blackfin, which are both 'newer'
ports. I imagine a lot of the early discussion around their merging will
be relevant to the score port as well.

Particularly eye their syscall table...

(sys_cacheflush? seriously? :)

I went through your patch when you posted it last week and made some
comments, I'll post them this weekend if I don't see them brought up by
Arnd or others.

regards, Kyle
