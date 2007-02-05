Return-Path: <linux-kernel-owner+w=401wt.eu-S1752624AbXBEAoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624AbXBEAoR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 19:44:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752626AbXBEAoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 19:44:17 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37427
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752624AbXBEAoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 19:44:16 -0500
Date: Sun, 04 Feb 2007 16:44:16 -0800 (PST)
Message-Id: <20070204.164416.85425216.davem@davemloft.net>
To: deweerdt@free.fr
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] remove tcp header from tcp_v4_check (take #2)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070112135514.GG5941@slug>
References: <20070111222627.66bb75ab.akpm@osdl.org>
	<20070112133309.GF5941@slug>
	<20070112135514.GG5941@slug>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederik Deweerdt <deweerdt@free.fr>
Date: Fri, 12 Jan 2007 13:55:14 +0000

> On Fri, Jan 12, 2007 at 01:33:09PM +0000, Frederik Deweerdt wrote:
> > On Thu, Jan 11, 2007 at 10:26:27PM -0800, Andrew Morton wrote:
> > > 
> > >   ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20-rc3/2.6.20-rc4-mm1/
> > > 
> Hi,
> 
> Sorry for the resend, I forgot the Signed-off-by line, and noticed a
> whitespace breakage in ipt_REJECT.
> The tcphdr struct passed to tcp_v4_check is not used, the following
> patch removes it from the parameter list.
> This adds the netfilter modifications missing in the patch I sent
> for rc3-mm1.
> 
> Regards,
> Frederik 
> 
> Signed-off-by: Frederik Deweerdt <frederik.deweerdt@gmail.com>

Applied, thanks Frederik.
