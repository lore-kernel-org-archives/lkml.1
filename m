Return-Path: <linux-kernel-owner+w=401wt.eu-S1760062AbXELQb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760062AbXELQb6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 12:31:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756243AbXELQbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 12:31:52 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:3737 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754412AbXELQbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 12:31:51 -0400
Date: Sat, 12 May 2007 17:31:41 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       David Woodhouse <dwmw2@infradead.org>,
       "YOSHIFUJI Hideaki / ?$B5HF#1QL@" <yoshfuji@linux-ipv6.org>,
       linux-kernel@vger.kernel.org
Subject: Re: linux-2.6.21-gitN - versioning question
Message-ID: <20070512163141.GC21729@flint.arm.linux.org.uk>
Mail-Followup-To: Cyrill Gorcunov <gorcunov@gmail.com>,
	Jan Engelhardt <jengelh@linux01.gwdg.de>,
	David Woodhouse <dwmw2@infradead.org>,
	"YOSHIFUJI Hideaki / ?$B5HF#1QL@" <yoshfuji@linux-ipv6.org>,
	linux-kernel@vger.kernel.org
References: <Pine.LNX.4.61.0705121316540.9570@yvahk01.tjqt.qr> <20070512.210308.93070730.yoshfuji@linux-ipv6.org> <20070512131906.GF8337@cvg> <1178977496.2802.5.camel@shinybook.infradead.org> <Pine.LNX.4.61.0705121701020.9570@yvahk01.tjqt.qr> <20070512162428.GB8366@cvg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070512162428.GB8366@cvg>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 12, 2007 at 08:24:28PM +0400, Cyrill Gorcunov wrote:
> [Jan Engelhardt - Sat, May 12, 2007 at 05:01:19PM +0200]
> | 
> | On May 12 2007 21:44, David Woodhouse wrote:
> | >On Sat, 2007-05-12 at 17:19 +0400, Cyrill Gorcunov wrote:
> | >> Actually I think it would be convenient if such tags (like
> | >> v.2.6.21-git16) were in Linus' git tree too.
> | >
> | >Then there would be _lots_ of tags in the master tree -- I'm not sure we
> | >want that.
> | >
> | >I suppose I could put a tree on kernel.org which _does_ have the tags,
> | >and which precisely matches Linus' tree in every other way... but then
> | >again, you could do that too by just rsyncing the tags yourself :)
> | 
> | Are you saying GIT tags are expensive, compared to, say, SVN tags?

(Sorry, don't have Jan's message.)

The real issue is not that, but that David doesn't have write access to
Linus' published tree.  Neither should he because he could contaminate
Linus' published tree with the MTD tree, or introduce some unreviewed
patch which gave him backdoor access via the kernel.

(Of course, David's unlikely to do either, but that's not really the
point.)

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
