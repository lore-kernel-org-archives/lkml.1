Return-Path: <linux-kernel-owner+w=401wt.eu-S1760237AbXEPLuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760237AbXEPLuu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 07:50:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756779AbXEPLum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 07:50:42 -0400
Received: from mail.shareable.org ([81.29.64.88]:36030 "EHLO
	mail.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756321AbXEPLul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 07:50:41 -0400
Date: Wed, 16 May 2007 12:18:40 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Albert Cahalan <acahalan@gmail.com>
Cc: =?iso-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>, akpm@osdl.org,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, Ingo Oeser <ioe-lkml@rameria.de>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-mtd@lists.infradead.org,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, linux-fsdevel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] LogFS take three
Message-ID: <20070516111840.GB20482@mail.shareable.org>
References: <20070515151919.GA32510@lazybastard.org> <787b0d920705151626x3a11b81csf0f3747a695131b0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <787b0d920705151626x3a11b81csf0f3747a695131b0@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Albert Cahalan wrote:
> Please don't forget the immutable bit. ("man lsattr")
> Having both, BSD-style, would be even better.
> The immutable bit is important for working around
> software bugs and "features" that damage files.
> 
> I also can't find xattr support.

Imho,

Given that the filesystem is still 'experimental', I'd concentrate on
getting it stable before worrying about immutable and xattrs unless
they are easy.  (Immutable is easy).

In 13 years of using Linux in all sorts of ways I've never yet to use
either feature.  They would be good to have, but stability in a
filesystem is much more useful.

I'm biased of course: if LogFS were stable and well tested, I'd be
using it right now in my embedded thingy - and that doesn't even
bother with uids :-)

-- Jamie
