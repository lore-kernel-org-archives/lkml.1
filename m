Return-Path: <linux-kernel-owner+w=401wt.eu-S1946255AbXD3QNi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946255AbXD3QNi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 12:13:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945999AbXD3QN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 12:13:27 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48011 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946258AbXD3QNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 12:13:21 -0400
Date: Mon, 30 Apr 2007 17:13:18 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Latchesar Ionkov <lionkov@gmail.com>
Cc: Andrew Morton <akpm@osdl.org>, Linux Kernel <linux-kernel@vger.kernel.org>,
       V9FS Developers <v9fs-developer@lists.sourceforge.net>
Subject: Re: [PATCH] 9p: create separate 9p client interface
Message-ID: <20070430161318.GA29321@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Latchesar Ionkov <lionkov@gmail.com>, Andrew Morton <akpm@osdl.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	V9FS Developers <v9fs-developer@lists.sourceforge.net>
References: <f158dc670704300832l36889bf2kfa4480addbe8cfb2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f158dc670704300832l36889bf2kfa4480addbe8cfb2@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2007 at 09:32:41AM -0600, Latchesar Ionkov wrote:
> Create a separate 9P client interface that can be used outside the VFS
> layer. In addition to VFS, the new interface can be used to export the
> authentication channel or from other interfaces.

And what exact users would that be?  We have a huge dislike for putting
abstractions in just for the abstractions sake, so if you want this
merged you'd better present a highly useful client to that interface.

Also the non-filesystem interface code shouldn't live in fs/ but
rather in net/9p/

