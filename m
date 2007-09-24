Return-Path: <linux-kernel-owner+w=401wt.eu-S1758597AbXIXMgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758597AbXIXMgz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 08:36:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756102AbXIXMgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 08:36:46 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40200 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257AbXIXMgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 08:36:45 -0400
Date: Mon, 24 Sep 2007 13:36:40 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: hch@infradead.org, trond.myklebust@fys.uio.no, adilger@clusterfs.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [patch 1/2] VFS: new fgetattr() file operation
Message-ID: <20070924123640.GA17409@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Miklos Szeredi <miklos@szeredi.hu>, trond.myklebust@fys.uio.no,
	adilger@clusterfs.com, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
References: <E1IZmze-0003q9-00@dorka.pomaz.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1IZmze-0003q9-00@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2007 at 02:24:54PM +0200, Miklos Szeredi wrote:
> Thanks to everyone for the feedback.  Here's two of the VFS patches
> reworked according to comments.  I also plan to rework the setattr()
> patch accordingly and perhaps the xattr patch, altough that is the
> lowest priority.
> 
> Christoph, are these OK with you in this form?

Not at all.  Attribute operations like this have no business at all
looking at the struct file.  Please fix your dreaded filesystem to
implement proper unix semantics intead, and if that means adding
silly rename support so be it.

