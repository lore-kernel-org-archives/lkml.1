Return-Path: <linux-kernel-owner+w=401wt.eu-S969645AbXEHXKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969645AbXEHXKR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 19:10:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969552AbXEHXJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 19:09:54 -0400
Received: from lazybastard.de ([212.112.238.170]:34175 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S969130AbXEHXJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 19:09:53 -0400
Date: Wed, 9 May 2007 01:05:34 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Ingo Oeser <ioe-lkml@rameria.de>
Cc: tglx@linutronix.de, Andrew Morton <akpm@osdl.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 1/2] LogFS proper
Message-ID: <20070508230534.GA25920@lazybastard.org>
References: <20070507215913.GA15054@lazybastard.org> <20070507220036.GB15054@lazybastard.org> <1178608950.3042.273.camel@localhost.localdomain> <200705090044.16096.ioe-lkml@rameria.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200705090044.16096.ioe-lkml@rameria.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 May 2007 00:44:14 +0200, Ingo Oeser wrote:
> On Tuesday 08 May 2007, Thomas Gleixner wrote:
> > On Tue, 2007-05-08 at 00:00 +0200, Jörn Engel wrote:
> > > +#define packed __attribute__((__packed__))
> > 
> > Please use the __attribute__((__packed__)) on your structs instead of
> > creating some extra "needs lookup" magic.
> 
> Don't worry, we have __packed predefined for this. 
> Just look in include/linux/compiler-gcc.h
> 
> I love it, because I always forget at least one brace or undescore level :-)

Cool!  Will take that.

Jörn

-- 
Audacity augments courage; hesitation, fear.
-- Publilius Syrus
