Return-Path: <linux-kernel-owner+w=401wt.eu-S1760639AbYGOAoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760639AbYGOAoV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 20:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757112AbYGOAoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 20:44:13 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44690 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756710AbYGOAoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 20:44:13 -0400
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
	in-kernel, use it in more drivers.
From: David Woodhouse <dwmw2@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: david@lang.hm, Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.1.10.0807141738360.3017@woody.linux-foundation.org>
References: <1216077806.27455.85.camel@shinybook.infradead.org>
	 <20080714164119.99c33d5b.akpm@linux-foundation.org>
	 <20080714165956.7fe2d4ee@infradead.org>
	 <alpine.DEB.1.10.0807141704120.14223@asgard.lang.hm>
	 <1216082213.27455.109.camel@shinybook.infradead.org>
	 <alpine.LFD.1.10.0807141738360.3017@woody.linux-foundation.org>
Content-Type: text/plain
Date: Mon, 14 Jul 2008 17:44:00 -0700
Message-Id: <1216082640.27455.116.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-14 at 17:40 -0700, Linus Torvalds wrote:
> 
> On Mon, 14 Jul 2008, David Woodhouse wrote:
> > 
> > I see no real point in that. If you have userspace to load modules, then
> > you have userspace to load firmware.
> 
> David, the case is different: the module is loaded _across_ the 
> suspend/resume, but the device needs to have its firmware reloaded at 
> resume time because it lost power.

Either I put my reply in response to the wrong quotation, or you thought
I did.

I intended the above to be a response to the "please put firmware _into_
the .ko file" request. Not to the suspend/resume thing.

Yes, I agree that suspend/resume is a non-issue.

-- 
dwmw2

