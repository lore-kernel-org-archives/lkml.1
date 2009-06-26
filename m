Return-Path: <linux-kernel-owner+w=401wt.eu-S1755856AbZFZWbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856AbZFZWbU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 18:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752337AbZFZWbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 18:31:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35646 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbZFZWbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 18:31:07 -0400
Message-ID: <4A454A69.4050301@zytor.com>
Date: Fri, 26 Jun 2009 15:23:37 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>, benh@kernel.crashing.org,
       paulus@samba.org
Subject: Re: [PATCH] gitignore: add *.bz2 and *.cpio to top-level; clean up
 usr/
References: <200906202056.n5KKuc9o013960@tazenda.hos.anvin.org> <1245569547.2480.18.camel@ht.satnam> <20090626222112.GB27048@uranus.ravnborg.org>
In-Reply-To: <20090626222112.GB27048@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> 
> I would prefer to have *.gz and *.lzma pushed out to the
> directories where it matters.
> There global ignore rules will bite us one day.
> 
> So I did not apply neither this nor Peter's original patch.
> 

I think that's the wrong answer, unless we somehow end up with
compressed files in the source.  At the moment, a *.gz file in the
source tree is much more likely to be a file in use by the developer.

	-hpa

