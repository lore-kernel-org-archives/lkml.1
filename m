Return-Path: <linux-kernel-owner+w=401wt.eu-S1161077AbXAZTZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161077AbXAZTZj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 14:25:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161209AbXAZTZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 14:25:39 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:43661 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161208AbXAZTZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 14:25:38 -0500
X-Originating-Ip: 74.109.98.130
Date: Fri, 26 Jan 2007 14:24:47 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Remove final vestiges of CONFIG_UNWIND_INFO.
In-Reply-To: <20070126191644.GA5534@martell.zuzino.mipt.ru>
Message-ID: <Pine.LNX.4.64.0701261422390.28424@CPE00045a9c397f-CM001225dbafb6>
References: <Pine.LNX.4.64.0701261301590.27767@CPE00045a9c397f-CM001225dbafb6>
 <20070126191644.GA5534@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jan 2007, Alexey Dobriyan wrote:

> On Fri, Jan 26, 2007 at 01:06:39PM -0500, Robert P. J. Day wrote:
> >   Remove the sole remaining reference to the apparently dead config
> > variable CONFIG_UNWIND_INFO.
>
> Regardless of unwinder future, patch doesn't update defconfigs all
> over the tree.

as i understand it, it's not supposed to.  it was explained to me once
that those defconfigs are regularly rebuilt, and will lose that
reference automatically once there's no corresponding kernel config
variable anymore.

someone care to clarify this?  because i remember distinctly once upon
a time being told *not* to mess with any defconfig files in a patch.

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://www.fsdev.dreamhosters.com/wiki/index.php?title=Main_Page
========================================================================
