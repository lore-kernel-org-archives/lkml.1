Return-Path: <linux-kernel-owner+w=401wt.eu-S965247AbXBTQHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965247AbXBTQHJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 11:07:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965243AbXBTQHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 11:07:08 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:56148 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965247AbXBTQHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 11:07:06 -0500
Subject: Re: [PATCH] aio: propogate post-EIOCBQUEUED errors to completion
	event
From: Arjan van de Ven <arjan@infradead.org>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Benjamin LaHaise <bcrl@kvack.org>, Chris Mason <chris.mason@oracle.com>,
       "Ananiev, Leonid I" <leonid.i.ananiev@intel.com>,
       Zach Brown <zach.brown@oracle.com>, linux-aio@kvack.org,
       linux-kernel@vger.kernel.org, Suparna bhattacharya <suparna@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1171987310.6271.23.camel@heimdal.trondhjem.org>
References: <20070219203527.20419.68418.sendpatchset@tetsuo.zabbo.net>
	 <B41635854730A14CA71C92B36EC22AAC83B044@mssmsx411>
	 <20070219215048.GI6133@think.oraclecorp.com>
	 <20070220002109.GG31205@kvack.org>
	 <1171987310.6271.23.camel@heimdal.trondhjem.org>
Content-Type: text/plain
Organization: Intel International BV
Date: Tue, 20 Feb 2007 17:06:47 +0100
Message-Id: <1171987607.3531.142.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> We don't try to resolve "conflicting" writes between ordinary mmap() and
> write(), so why should we be doing it for mmap and O_DIRECT?
> 
> mmap() is designed to violate the ordinary mutex locks for write(), so
> if a conflict arises, whether it be with O_DIRECT or ordinary writes
> then it is a case of "last writer wins".

but.. wouldn't an O_DIRECT *read* even cause this?


