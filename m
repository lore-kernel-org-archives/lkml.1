Return-Path: <linux-kernel-owner+w=401wt.eu-S1757593AbXKGGKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757593AbXKGGKU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 01:10:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755387AbXKGGKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 01:10:04 -0500
Received: from 1wt.eu ([62.212.114.60]:3747 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821AbXKGGKB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 01:10:01 -0500
Date: Wed, 7 Nov 2007 07:09:41 +0100
From: Willy Tarreau <w@1wt.eu>
To: Romano Giannetti <romano@dea.icai.upcomillas.es>
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>, Roland Dreier <rdreier@cisco.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.34-rc1 eat my photo SD card :-(
Message-ID: <20071107060941.GA22707@1wt.eu>
References: <1194168583.10245.15.camel@rukbat> <ada8x5ec7oh.fsf@cisco.com> <1194259886.6927.9.camel@localhost> <20071105132218.495f244e@poseidon.drzeus.cx> <1194270393.27789.2.camel@localhost> <20071105162633.09e54290@poseidon.drzeus.cx> <1194343121.6953.6.camel@rukbat> <20071106195148.GD1045@1wt.eu> <1194385693.12938.5.camel@rukbat> <1194387459.5205.2.camel@rukbat>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1194387459.5205.2.camel@rukbat>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2007 at 11:17:39PM +0100, Romano Giannetti wrote:
> On Tue, 2007-11-06 at 22:48 +0100, Romano Giannetti wrote:
> 
> > I do really suspect a software bug.
> >
> 
> Well, I started bisecting it. It will be a long shot, I suspect...
> 
> 	Romano
> 
> BTW: I noticed that if I change EXTRAVERSION, doing a make rebuild
> almost all the kernel. Is it normal?

yes I think, because it changes version.h which is included directly or
indirectly by every file.

> And it seems to me that the same
> thing happens if a make oldconfig results in a changed .config...

this should not happen IMHO. If you post a simple reproducible case, maybe
some people can investigate it.

Regards,
Willy

