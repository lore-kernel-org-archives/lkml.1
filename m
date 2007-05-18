Return-Path: <linux-kernel-owner+w=401wt.eu-S1762908AbXERTNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762908AbXERTNm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 15:13:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756685AbXERTNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 15:13:36 -0400
Received: from c-68-45-216-119.hsd1.nj.comcast.net ([68.45.216.119]:4096 "EHLO
	mail.cyberdogtech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893AbXERTNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 15:13:35 -0400
X-Greylist: delayed 7500 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 May 2007 15:13:35 EDT
Date: Fri, 18 May 2007 15:09:53 -0400
From: Matt LaPlante <kernel1@cyberdogtech.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] 2.6.21-git15 - Kconfig Cleanup
Message-Id: <20070518150953.c647230b.kernel1@cyberdogtech.com>
In-Reply-To: <20070518180154.GA6291@stusta.de>
References: <20070511220501.02181278.kernel1@cyberdogtech.com>
	<20070518130441.060a9190.kernel1@cyberdogtech.com>
	<20070518180154.GA6291@stusta.de>
X-Mailer: Sylpheed 2.4.0 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Processed: mail.cyberdogtech.com, Fri, 18 May 2007 15:09:56 -0400
	(not processed: message from valid local sender)
X-Return-Path: kernel1@cyberdogtech.com
X-Envelope-From: kernel1@cyberdogtech.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
X-MDAV-Processed: mail.cyberdogtech.com, Fri, 18 May 2007 15:09:57 -0400
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 May 2007 20:01:54 +0200
Adrian Bunk <bunk@stusta.de> wrote:

> On Fri, May 18, 2007 at 01:04:41PM -0400, Matt LaPlante wrote:
> 
> > ping?
> 
> Noone disagreed, and trivial patches will be forwarded again during the 
> 2.6.23 merge window.

Ok, I didn't know it would be acceptable without an ack from someone... (is Randy on vacation? :)

I know we've discussed the logic behind trivial merges going in prior
to RC candidates, and generally I think it's sound enough (we don't
want to disrupt the merging of patches that actually "matter," etc).
I don't want to create a redundant conversation here, but I'm
compelled to ask for opinions on this...  I think the Kconfigs are a
fairly prominent kernel feature, and would expect a lot of systems
people will be seeing them when the new version goes final.  That also
means that a lot more people will be seeing the "trivial" errors in
spelling or grammar that are being left in until the next version.  In
this round, for example, the new blackfin entries were really in need
of some love.

I don't really know how many people will report such things, or submit
duplicate patches for them before we actually get to the next kernel
cycle, but it seems like a waste to me.  I don't really care so much
about fixes to the Documentation texts or source comments because, in
my estimation, they probably have a much smaller audience than the
kernel configuration interface.  I guess I'm just more sensitive to
the presentation aspects of a project than the average developer, but
I can't help feel it's a shame when we're willing to show the public
such an unpolished face in a "final" product.  To me, good code is
taken down a notch by haphazard presentation.

Thoughts?

Cheers,
Matt

> 
> cu
> Adrian
> 
> -- 
> 
>        "Is there not promise of rain?" Ling Tan asked suddenly out
>         of the darkness. There had been need of rain for many days.
>        "Only a promise," Lao Er said.
>                                        Pearl S. Buck - Dragon Seed
> 


-- 
Matt LaPlante
CCNP, CCDP, A+, Linux+, CQS
kernel1@cyberdogtech.com

