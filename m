Return-Path: <linux-kernel-owner+w=401wt.eu-S933612AbXEFLP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933612AbXEFLP4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 07:15:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754711AbXEFLP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 07:15:56 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39659 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665AbXEFLPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 07:15:55 -0400
Date: Sun, 6 May 2007 12:15:54 +0100
From: Christoph Hellwig <hch@infradead.org>
To: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, akpm@linux-foundation.org, viro@ftp.linux.org.uk,
       Trond.Myklebust@netapp.com, neilb@suse.de, mhalcrow@us.ibm.com
Subject: Re: [PATCH 4/4] fs: Remove path_walk export
Message-ID: <20070506111554.GD1211@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	akpm@linux-foundation.org, viro@ftp.linux.org.uk,
	Trond.Myklebust@netapp.com, neilb@suse.de, mhalcrow@us.ibm.com
References: <11784065741163-git-send-email-jsipek@cs.sunysb.edu> <1178406574518-git-send-email-jsipek@cs.sunysb.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1178406574518-git-send-email-jsipek@cs.sunysb.edu>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 05, 2007 at 07:09:34PM -0400, Josef 'Jeff' Sipek wrote:
> Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
> ---
>  fs/namei.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)

it should be possible to make it static now aswell.  (the uml code
using it is #if0'ed and will never be resurrected because it's quite bogus).

Also link_path_walk can become static aswell.  It will need a forward
declaration though as it's used recursively.

