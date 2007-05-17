Return-Path: <linux-kernel-owner+w=401wt.eu-S1756520AbXEQPvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756520AbXEQPvQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 11:51:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755019AbXEQPvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 11:51:04 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56791 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754960AbXEQPvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 11:51:04 -0400
Subject: Re: [PATCH] ubi: kill homegrown endian macros
From: David Woodhouse <dwmw2@infradead.org>
To: Christoph Hellwig <hch@lst.de>
Cc: dedekind@infradead.org, akpm@osdl.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070517143200.GA30850@lst.de>
References: <20070517143200.GA30850@lst.de>
Content-Type: text/plain
Date: Thu, 17 May 2007 23:50:54 +0800
Message-Id: <1179417055.2859.506.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7.dwmw2.2) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-17 at 16:32 +0200, Christoph Hellwig wrote:
> Kill ubis homegrown endianess handling crap and replace it with
> the normal kernel endianess handling. 

NAK. The 'normal' kernel stuff doesn't work in GCC; only in sparse.

If you want to go removing the ones which _do_ work in GCC, then fix the
'normal' one first. _Then_ go about converting others over to it.

-- 
dwmw2

