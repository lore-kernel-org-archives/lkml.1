Return-Path: <linux-kernel-owner+w=401wt.eu-S1762495AbXJQUZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762495AbXJQUZo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 16:25:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757777AbXJQUZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 16:25:36 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39984 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757036AbXJQUZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 16:25:35 -0400
Date: Wed, 17 Oct 2007 13:24:21 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jgarzik@pobox.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [bug] ata subsystem related crash with latest -git
In-Reply-To: <20071017200638.GE15552@kernel.dk>
Message-ID: <alpine.LFD.0.999.0710171321400.26902@woody.linux-foundation.org>
References: <20071017172932.GI15552@kernel.dk> <20071017173408.GA1960@elte.hu>
 <20071017174503.GA4622@elte.hu> <20071017175337.GN15552@kernel.dk>
 <20071017183716.GU15552@kernel.dk> <20071017190901.GA13780@elte.hu>
 <alpine.LFD.0.999.0710171217160.26902@woody.linux-foundation.org>
 <20071017193542.GA15552@kernel.dk> <alpine.LFD.0.999.0710171244330.26902@woody.linux-foundation.org>
 <20071017195659.GD15552@kernel.dk> <20071017200638.GE15552@kernel.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 17 Oct 2007, Jens Axboe wrote:
> 
> So until that is fixed up, how about this? Should cover all block
> devices, and I don't think sg_next()/for_each_sg() has spread outside of
> that yet.

Heh. Not good. There are drivers that set max phys segmsnts to 1. Either 
through some host-specific setting (MMC), or explicitly (eg a grep shows 
viodasd uses just a constant 1 there).

		Linus
