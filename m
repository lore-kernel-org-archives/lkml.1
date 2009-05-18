Return-Path: <linux-kernel-owner+w=401wt.eu-S1754971AbZERBho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971AbZERBho (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 21:37:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751101AbZERBhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 21:37:34 -0400
Received: from sh.osrg.net ([192.16.179.4]:55507 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774AbZERBhe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 21:37:34 -0400
Date: Mon, 18 May 2009 10:36:09 +0900
To: jeremy@goop.org
Cc: mingo@elte.hu, x86@kernel.org, linux-kernel@vger.kernel.org,
       xen-devel@lists.xensource.com, gregkh@suse.de, okir@suse.de
Subject: Re: Where do we stand with the Xen patches?
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4A0C770E.2030305@goop.org>
References: <4A0C770E.2030305@goop.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090518103520J.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 18 May 2009 10:36:11 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 May 2009 12:54:54 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Hi Ingo,
> 
> Over the last week or so, I've set out pull requests for the following 
> branches in git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git :
> 
> for-ingo/xen/dom0/core
> 
>     You made two comments about the first post of this set:
> 
>        1. The // comments in the mtrr code.  Now fixed.
>        2. A query about when Xen can support PAT.  In progress; when its
>           done, we can remove the unconditional PAT disable.
> 
> for-ingo/xen/dom0/pci
> for-ingo/xen/dom0/swiotlb
> 
>     Updated with Joerg Roedel, FUJITA Tomonori and Matthew Wilcox's
>     comments,  Acked-by and Reviewed-bys as appropriate.

The original code added dom0-specific dma mapping stuff in the generic
place, which is completely wrong. I asked you to move the hacky stuff
to Xen-specific code and ack'ed the patchset.

But as I said again and again, the dom0 changes to the generic dma
mapipng code is really ugly and I don't like them at all. I didn't
ack'ed such changes.
