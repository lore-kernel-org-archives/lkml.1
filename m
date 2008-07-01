Return-Path: <linux-kernel-owner+w=401wt.eu-S1756662AbYGAMWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662AbYGAMWS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 08:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752623AbYGAMWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 08:22:08 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37943 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465AbYGAMWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 08:22:05 -0400
Date: Tue, 1 Jul 2008 08:22:04 -0400
From: Christoph Hellwig <hch@infradead.org>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] fat: cleanup fs/fat/dir.c
Message-ID: <20080701122204.GC25580@infradead.org>
References: <9edbdefc3e848699cfe111608.ps@mail.parknet.co.jp> <129170883e848699cff211608.ps@mail.parknet.co.jp> <d3ce91fd3e848699cff311608.ps@mail.parknet.co.jp> <5be8ad613e848699cff411608.ps@mail.parknet.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5be8ad613e848699cff411608.ps@mail.parknet.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2008 at 11:57:03AM +0900, OGAWA Hirofumi wrote:
> 
> This is no logic changes, just cleans fs/fat/dir.c up.

I don't think it makes sense to mark the new functions inline, they are
quite big, and if it really makes sense to inline them the compiler will
do it for us.

