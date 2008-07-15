Return-Path: <linux-kernel-owner+w=401wt.eu-S1756613AbYGOQWL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613AbYGOQWL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 12:22:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752515AbYGOQV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 12:21:58 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56968 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430AbYGOQV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 12:21:57 -0400
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
	in-kernel, use it in more drivers.
From: David Woodhouse <dwmw2@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: david@lang.hm, Willy Tarreau <w@1wt.eu>,
       David Miller <davem@davemloft.net>, jeff@garzik.org,
       arjan@infradead.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.1.10.0807150843580.3017@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org>
	 <487C09EB.1050903@garzik.org>
	 <alpine.LFD.1.10.0807141928540.3017@woody.linux-foundation.org>
	 <20080714.194032.117461306.davem@davemloft.net>
	 <alpine.LFD.1.10.0807141947540.3017@woody.linux-foundation.org>
	 <20080715045848.GG1369@1wt.eu>
	 <alpine.LFD.1.10.0807150747540.3017@woody.linux-foundation.org>
	 <alpine.DEB.1.10.0807150759020.6370@asgard>
	 <alpine.LFD.1.10.0807150843580.3017@woody.linux-foundation.org>
Content-Type: text/plain
Date: Tue, 15 Jul 2008 09:21:20 -0700
Message-Id: <1216138880.27455.262.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-15 at 09:01 -0700, Linus Torvalds wrote:
> (I don't think we have source for more than one or two cases).

We don't. As part of the cleanup I've been trying to document what we
know about the origins of the firmware, in the firmware/WHENCE file. 
Unfortunately, mostly that's just "unknown".

We have managed to dig out the original source for one or two hex arrays
though.

-- 
dwmw2

