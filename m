Return-Path: <linux-kernel-owner+w=401wt.eu-S1760426AbZLQRwN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760426AbZLQRwN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 12:52:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751006AbZLQRwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 12:52:08 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34255 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750753AbZLQRwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 12:52:01 -0500
Date: Thu, 17 Dec 2009 09:51:10 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: tytso@mit.edu
cc: Kyle McMartin <kyle@mcmartin.ca>, linux-parisc@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       James.Bottomley@suse.de, hch@infradead.org, linux-arch@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [git patches] xfs and block fixes for virtually indexed arches
In-Reply-To: <20091217173957.GG2123@thunk.org>
Message-ID: <alpine.LFD.2.00.0912170950330.15740@localhost.localdomain>
References: <20091216043618.GB9104@hera.kernel.org> <20091217132256.GO28962@bombadil.infradead.org> <alpine.LFD.2.00.0912170811130.15740@localhost.localdomain> <20091217163036.GE2123@thunk.org> <alpine.LFD.2.00.0912170839550.15740@localhost.localdomain>
 <20091217173957.GG2123@thunk.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 17 Dec 2009, tytso@mit.edu wrote:
> 
> Sure, but there's some rumors/oral traditions going around that some
> block devices want bio address which are page aligned, because they
> want to play some kind of refcounting game,

Yeah, you might be right at that.

> And it's Weird Shit(tm) (aka iSCSI, AoE) type drivers, that most of us 
> don't have access to, so just because it works Just Fine on SATA doesn't 
> mean anything.
> 
> And none of this is documented anywhere, which is frustrating as hell.
> Just rumors that "if you do this, AoE/iSCSI will corrupt your file
> systems".

ACK. Jens? 

		Linus
