Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314Ab0CMCPH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 21:15:07 -0500
Received: from lo.gmane.org ([80.91.229.12]:54621 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756118Ab0CMCPF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 21:15:05 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [PATCH] firmware loader: use statically initialized data attribute
Date: Sat, 13 Mar 2010 02:08:49 +0000 (UTC)
Message-ID: <loom.20100313T030500-863@post.gmane.org>
References: <20100311083111.GA11183@core.coreip.homeip.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 58.89.190.212 (Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.14) Gecko/2009091010 Iceweasel/3.0.6 (Debian-3.0.6-1))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov <dmitry.torokhov <at> gmail.com> writes:

> There is no reason why we are using a template for binary attribute
> and copying it into per-firmware data before registering. Using the
> original works as well and gets rid of the following lockdep
> compaint:
[...]
> Signed-off-by: Dmitry Torokhov <dtor <at> mail.ru>

Acked-by: Wolfram Sang <w.sang@pengutronix.de>


