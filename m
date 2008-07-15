Return-Path: <linux-kernel-owner+w=401wt.eu-S1761961AbYGORon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761961AbYGORon (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 13:44:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754063AbYGORoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 13:44:34 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47314 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454AbYGORoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 13:44:34 -0400
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
	in-kernel, use it in more drivers.
From: David Woodhouse <dwmw2@infradead.org>
To: Willy Tarreau <w@1wt.eu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, jeff@garzik.org,
       arjan@infradead.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
In-Reply-To: <20080715173520.GA30521@1wt.eu>
References: <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org>
	 <487C09EB.1050903@garzik.org>
	 <alpine.LFD.1.10.0807141928540.3017@woody.linux-foundation.org>
	 <20080714.194032.117461306.davem@davemloft.net>
	 <alpine.LFD.1.10.0807141947540.3017@woody.linux-foundation.org>
	 <20080715045848.GG1369@1wt.eu>
	 <alpine.LFD.1.10.0807150747540.3017@woody.linux-foundation.org>
	 <20080715173520.GA30521@1wt.eu>
Content-Type: text/plain
Date: Tue, 15 Jul 2008 10:44:05 -0700
Message-Id: <1216143845.27455.304.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-15 at 19:35 +0200, Willy Tarreau wrote:
> It's not only a problem of transfer, but also a problem of selection
> of what to copy overthere.

This is why the MODULE_FIRMWARE() tag exists.

Most scripts tend to get this right already -- they _have_ to, since
modern drivers have been using request_firmware() for some time already.

> Please don't compare an upgrade of a working desktop or developer
> machine with an installation from scratch of a server in an
> uncomfortable location. Those are two completely different things.

If your setup doesn't cope with MODULE_FIRMWARE(), it's likely to break
when you next deploy a new server anyway -- because your new server will
have new hardware, and your new hardware will have a modern driver. And
modern drivers use request_firmware() _anyway_.

-- 
dwmw2

