Return-Path: <linux-kernel-owner+w=401wt.eu-S1756306AbXEFVSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306AbXEFVSr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 17:18:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755978AbXEFVSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 17:18:46 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42881 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756028AbXEFVSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 17:18:45 -0400
Date: Sun, 6 May 2007 22:18:44 +0100
From: Christoph Hellwig <hch@infradead.org>
To: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, akpm@linux-foundation.org, viro@ftp.linux.org.uk,
       Trond.Myklebust@netapp.com, neilb@suse.de, mhalcrow@us.ibm.com
Subject: Re: [PATCH 2/5] sunrpc: Use vfs_path_lookup
Message-ID: <20070506211844.GB13333@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	akpm@linux-foundation.org, viro@ftp.linux.org.uk,
	Trond.Myklebust@netapp.com, neilb@suse.de, mhalcrow@us.ibm.com
References: <1178473289617-git-send-email-jsipek@cs.sunysb.edu> <1178473289960-git-send-email-jsipek@cs.sunysb.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1178473289960-git-send-email-jsipek@cs.sunysb.edu>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 06, 2007 at 01:41:26PM -0400, Josef 'Jeff' Sipek wrote:
> use vfs_path_lookup instead of open-coding the necessary functionality.
> 
> Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
> Acked-by: Trond Myklebust <Trond.Myklebust@netapp.com>
> ---
>  net/sunrpc/rpc_pipe.c |   16 +++++++---------
>  1 files changed, 7 insertions(+), 9 deletions(-)

Looks good to me.

