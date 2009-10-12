Return-Path: <linux-kernel-owner+w=401wt.eu-S932244AbZJLOUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932244AbZJLOUx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 10:20:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932234AbZJLOUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 10:20:52 -0400
Received: from lo.gmane.org ([80.91.229.12]:42531 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932233AbZJLOUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 10:20:52 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Nick Bowler <nbowler@draconx.ca>
Subject: Re: [Regression, bisected] Transmit failure in et131x.
Date: Mon, 12 Oct 2009 14:19:41 +0000 (UTC)
Message-ID: <loom.20091012T161612-769@post.gmane.org>
References: <20091008140805.GA21535@emergent.ellipticsemi.com> <20091009112016.4fb07eb7@lxorguk.ukuu.org.uk> <loom.20091012T004346-812@post.gmane.org> <20091012113629.4ed8e7f4@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 99.240.144.239 (Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.3) Gecko/20090912 Gentoo Shiretoko/3.5.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan <at> lxorguk.ukuu.org.uk> writes:
> > Thanks a lot for your help.  Alas, this does not resolve the issue.
> > Using tcpdump indicates that receive continues to work while transmit
> > fails.
> > 
> > I was using gigabit, but the problem persists when I run at 100mbit.
> > The MTU setting remains at the default 1500 bytes.
> 
> et131x: Fix the add_10bit macro

That seems to have done the trick (in conjunction with the earlier patch,
at least) -- thanks!

Reported-and-tested-by: Nick Bowler <nbowler@elliptictech.com>

