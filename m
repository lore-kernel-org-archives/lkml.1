Return-Path: <linux-kernel-owner+w=401wt.eu-S1755352AbYGOFUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352AbYGOFUI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 01:20:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752183AbYGOFT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 01:19:57 -0400
Received: from gate.crashing.org ([63.228.1.57]:34749 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752030AbYGOFT4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 01:19:56 -0400
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
	in-kernel, use it in more drivers.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: David Woodhouse <dwmw2@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, david@lang.hm,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
In-Reply-To: <1216082640.27455.116.camel@shinybook.infradead.org>
References: <1216077806.27455.85.camel@shinybook.infradead.org>
	 <20080714164119.99c33d5b.akpm@linux-foundation.org>
	 <20080714165956.7fe2d4ee@infradead.org>
	 <alpine.DEB.1.10.0807141704120.14223@asgard.lang.hm>
	 <1216082213.27455.109.camel@shinybook.infradead.org>
	 <alpine.LFD.1.10.0807141738360.3017@woody.linux-foundation.org>
	 <1216082640.27455.116.camel@shinybook.infradead.org>
Content-Type: text/plain
Date: Tue, 15 Jul 2008 15:05:07 +1000
Message-Id: <1216098307.7740.54.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-14 at 17:44 -0700, David Woodhouse wrote:
> On Mon, 2008-07-14 at 17:40 -0700, Linus Torvalds wrote:
> > 
> > On Mon, 14 Jul 2008, David Woodhouse wrote:
> > > 
> > > I see no real point in that. If you have userspace to load modules, then
> > > you have userspace to load firmware.
> > 
> > David, the case is different: the module is loaded _across_ the 
> > suspend/resume, but the device needs to have its firmware reloaded at 
> > resume time because it lost power.
> 
> Either I put my reply in response to the wrong quotation, or you thought
> I did.
> 
> I intended the above to be a response to the "please put firmware _into_
> the .ko file" request. Not to the suspend/resume thing.
> 
> Yes, I agree that suspend/resume is a non-issue.

Besides, request_firmware() from a resume() method is broken. Has always
been and will probably always be.

Ben.

