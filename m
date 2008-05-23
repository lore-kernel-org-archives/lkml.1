Return-Path: <linux-kernel-owner+w=401wt.eu-S1757095AbYEWJST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757095AbYEWJST (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 05:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754526AbYEWJSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 05:18:08 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44961 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753910AbYEWJSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 05:18:05 -0400
Date: Fri, 23 May 2008 05:18:05 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, hch@infradead.org, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org, Steven Whitehouse <swhiteho@redhat.com>
Subject: Re: [patch 04/14] gfs2: dont call permission()
Message-ID: <20080523091805.GB27119@infradead.org>
References: <20080521171458.077908538@szeredi.hu> <20080521171546.697638614@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080521171546.697638614@szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bad idea.  You're duplicating bits out of permission for no good
reason.  I spent quite a bit of effort to make sure we don't have
this duplicated logic around.

