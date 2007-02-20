Return-Path: <linux-kernel-owner+w=401wt.eu-S1030269AbXBTQrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030269AbXBTQrQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 11:47:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030270AbXBTQrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 11:47:16 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55238 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030269AbXBTQrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 11:47:15 -0500
Subject: Re: [PATCH 05/44 take 2] [UBI] internal common header
From: David Woodhouse <dwmw2@infradead.org>
To: Theodore Tso <tytso@mit.edu>
Cc: Artem Bityutskiy <dedekind@infradead.org>,
       Christoph Hellwig <hch@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20070220161252.GE3170@thunk.org>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
	 <20070217165449.5845.18238.sendpatchset@localhost.localdomain>
	 <20070219105445.GA16930@infradead.org> <1171976753.4039.27.camel@sauron>
	 <20070220145503.GC3170@thunk.org>
	 <1171984555.3518.5.camel@hades.cambridge.redhat.com>
	 <20070220152259.GD3170@thunk.org>
	 <1171985598.3518.8.camel@hades.cambridge.redhat.com>
	 <20070220161252.GE3170@thunk.org>
Content-Type: text/plain
Date: Tue, 20 Feb 2007 16:47:04 +0000
Message-Id: <1171990024.3518.14.camel@hades.cambridge.redhat.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-2.fc6.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-20 at 11:12 -0500, Theodore Tso wrote:
>  I thought it was a gcc attribute as well, but it looks like it
> isn't.   

Indeed, which is why I've never really been tempted to switch JFFS2 to
__[bl]e32 rather than the structures it currently uses. Sparse is all
very nice and all, but no substitute for just making the real compiler
barf when you forget to byteswap.

-- 
dwmw2

