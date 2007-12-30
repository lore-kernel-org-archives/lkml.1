Return-Path: <linux-kernel-owner+w=401wt.eu-S1755863AbXL3TSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863AbXL3TSh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 14:18:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753077AbXL3TS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 14:18:28 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:58113 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbXL3TS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 14:18:27 -0500
Date: Sun, 30 Dec 2007 19:18:25 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       kernel-janitors <kernel-janitors@vger.kernel.org>
Subject: Re: [RFC][PATCH] byteorder: introduce le32_add_cpu & friends to
	core
Message-ID: <20071230191825.GA6447@infradead.org>
References: <20071230190619.GA13757@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071230190619.GA13757@joi>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 30, 2007 at 08:06:34PM +0100, Marcin Slusarz wrote:
> There are many places where these functions would be useful.
> (just look at: grep -r 'cpu_to_[ble12346]*([ble12346]*_to_cpu.*[-+]' linux-src/)
> What do you think?
> 
> ps: this patch depends on http://lkml.org/lkml/2007/12/25/35
> --
> 
> add inline functions which add native byte order variable to
> little/big endian variable to core header and as an example
> convert ext3 to use them

Various places already have this as be*_add / le*_add, so it might be
more useful to keep those names already in use.

