Return-Path: <linux-kernel-owner+w=401wt.eu-S1767703AbXEDHen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767703AbXEDHen (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 03:34:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767711AbXEDHen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 03:34:43 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51513 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767703AbXEDHem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 03:34:42 -0400
Date: Fri, 4 May 2007 08:34:37 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Josef Sipek <jsipek@cs.sunysb.edu>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, viro@ftp.linux.org.uk,
       Trond.Myklebust@netapp.com, mhalcrow@us.ibm.com
Subject: Re: [PATCH 1/1] fs: add 4th case to do_path_lookup
Message-ID: <20070504073437.GA22401@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Josef Sipek <jsipek@cs.sunysb.edu>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, viro@ftp.linux.org.uk,
	Trond.Myklebust@netapp.com, mhalcrow@us.ibm.com
References: <20070430032624.GA32047@filer.fsl.cs.sunysb.edu> <20070430033012.GB32047@filer.fsl.cs.sunysb.edu> <20070504000200.d14bd8d9.akpm@linux-foundation.org> <20070504072734.GA21188@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070504072734.GA21188@infradead.org>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Oh and btw, net/sunrpc/rpc_pipe.c:rpc_lookup_parent() and
fs/nfsctl.c:do_open() should  be switched to the new code, at which
point the path_walk() export can go.
