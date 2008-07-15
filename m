Return-Path: <linux-kernel-owner+w=401wt.eu-S1759260AbYGOFcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759260AbYGOFcf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 01:32:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753580AbYGOFc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 01:32:27 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49441 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149AbYGOFc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 01:32:26 -0400
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
	in-kernel, use it in more drivers.
From: David Woodhouse <dwmw2@infradead.org>
To: Willy Tarreau <w@1wt.eu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080715050654.GH1369@1wt.eu>
References: <1216077806.27455.85.camel@shinybook.infradead.org>
	 <20080714164119.99c33d5b.akpm@linux-foundation.org>
	 <20080714165956.7fe2d4ee@infradead.org> <487C0365.5030203@garzik.org>
	 <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org>
	 <487C09EB.1050903@garzik.org>
	 <alpine.LFD.1.10.0807141928540.3017@woody.linux-foundation.org>
	 <487C1648.5070409@garzik.org>
	 <alpine.LFD.1.10.0807142027140.3017@woody.linux-foundation.org>
	 <20080715050654.GH1369@1wt.eu>
Content-Type: text/plain
Date: Mon, 14 Jul 2008 22:32:10 -0700
Message-Id: <1216099930.27455.205.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-15 at 07:06 +0200, Willy Tarreau wrote:
> This is just a matter of point of view. From my POV, having to feed
> several unrelated files into a system to be able to get it to support
> any device is moving backwards, compared to the currently clean
> all-in-1 driver model.

So you disapprove of having to load mac80211.ko before your wireless NIC
driver? Or sungem_phy.ko before sungem.ko? Or libphy.ko before various
other drivers?

Or having to install /sbin/modprobe before you can load modules?

-- 
dwmw2

