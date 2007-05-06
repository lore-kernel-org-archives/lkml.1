Return-Path: <linux-kernel-owner+w=401wt.eu-S1750881AbXEFVVH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750881AbXEFVVH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 17:21:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750755AbXEFVVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 17:21:07 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42900 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbXEFVUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 17:20:11 -0400
Date: Sun, 6 May 2007 22:20:10 +0100
From: Christoph Hellwig <hch@infradead.org>
To: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, akpm@linux-foundation.org, viro@ftp.linux.org.uk,
       Trond.Myklebust@netapp.com, neilb@suse.de, mhalcrow@us.ibm.com
Subject: Re: [PATCH 4/5] fs: Mark link_path_walk static
Message-ID: <20070506212010.GD13333@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	akpm@linux-foundation.org, viro@ftp.linux.org.uk,
	Trond.Myklebust@netapp.com, neilb@suse.de, mhalcrow@us.ibm.com
References: <1178473289617-git-send-email-jsipek@cs.sunysb.edu> <11784732901486-git-send-email-jsipek@cs.sunysb.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11784732901486-git-send-email-jsipek@cs.sunysb.edu>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 06, 2007 at 01:41:28PM -0400, Josef 'Jeff' Sipek wrote:
> +/* forward declaration */
> +static int fastcall link_path_walk(const char *name, struct nameidata *nd);

I don't think we need that comment, otherwise this looks good.
