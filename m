Return-Path: <linux-kernel-owner+w=401wt.eu-S1752038Ab0AKKwD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038Ab0AKKwD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 05:52:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751532Ab0AKKvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 05:51:52 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:50908 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247Ab0AKKvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 05:51:50 -0500
Date: Mon, 11 Jan 2010 05:51:41 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Allow linker to eliminate unused functions in lib/*
Message-ID: <20100111105141.GA5550@infradead.org>
References: <20100105145917.GA25570@basil.fritz.box> <20100108162930.a011749a.akpm@linux-foundation.org> <20100109165155.GD20773@basil.fritz.box> <20100110231708.GC4019@discord.disaster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100110231708.GC4019@discord.disaster>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 11, 2010 at 10:17:08AM +1100, Dave Chinner wrote:
> Andi, how do you want to handle the overlap between this and the
> list_sort() patch I sent? I'm going to need a list_sort() available
> in the XFS tree well before the 2.6.34 merge window....

Honestly, if Andrew and Linus play with the game I'd just throw in your
patch to move the two indentical list_sort implementations into lib/
right now.  It's just moving stuff around so the normal merge window
shouldn't apply.  This would make life a lot easier for introducing new
users in .34.

