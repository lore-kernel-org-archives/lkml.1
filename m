Return-Path: <linux-kernel-owner+w=401wt.eu-S933644AbXEFLLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933644AbXEFLLq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 07:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933636AbXEFLLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 07:11:45 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39614 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933635AbXEFLLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 07:11:43 -0400
Date: Sun, 6 May 2007 12:11:39 +0100
From: Christoph Hellwig <hch@infradead.org>
To: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       hch@infradead.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/2] fs: Use path_walk in do_path_lookup
Message-ID: <20070506111139.GB1211@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <1178405980972-git-send-email-jsipek@cs.sunysb.edu> <11784059801600-git-send-email-jsipek@cs.sunysb.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11784059801600-git-send-email-jsipek@cs.sunysb.edu>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 05, 2007 at 06:59:40PM -0400, Josef 'Jeff' Sipek wrote:
> Since, path_walk sets the total_link_count to 0, and calls link_path_walk,
> we can just call path_walk directly.

Ok.

