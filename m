Return-Path: <linux-kernel-owner+w=401wt.eu-S932517AbXCGE3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932517AbXCGE3w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 23:29:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932636AbXCGE3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 23:29:52 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:54341 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932517AbXCGE3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 23:29:51 -0500
Subject: Re: Wanted: simple, safe x86 stack overflow detection
From: Arjan van de Ven <arjan@infradead.org>
To: Bill Irwin <bill.irwin@oracle.com>
Cc: Hugh Dickins <hugh@veritas.com>, Chuck Ebbert <cebbert@redhat.com>,
       Andi Kleen <andi@firstfloor.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20070306203432.GD18774@holomorphy.com>
References: <45E5913D.3080505@redhat.com>
	 <20070228204144.GA32316@one.firstfloor.org>
	 <20070304015031.GA4224@holomorphy.com> <45EDBA1B.8050007@redhat.com>
	 <Pine.LNX.4.64.0703061937450.19813@blonde.wat.veritas.com>
	 <20070306203432.GD18774@holomorphy.com>
Content-Type: text/plain
Organization: Intel International BV
Date: Tue, 06 Mar 2007 20:28:35 -0800
Message-Id: <1173241715.3236.16.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm certainly in favor of the move; IRQ stacks could be made
> rather deep and cheaply at that. I may get around to writing it this
> week if no one else does it first.

the irq stacks aren't the problem; RH at some point accidentally shipped
a kernel with 4k *shared* irq/user context stack and even that gave
almost no issues.

irq's really shouldn't actually nest; it's bad for just about everything
to do that (but that's another story, I would *love* to get rid of the
"enable irqs" thing in the x86 irq path, it hurts just about anything in
reality)

