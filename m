Return-Path: <linux-kernel-owner+w=401wt.eu-S1755045AbZGISc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045AbZGISc3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 14:32:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753611AbZGIScV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 14:32:21 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54841 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363AbZGIScV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 14:32:21 -0400
Date: Thu, 9 Jul 2009 14:32:20 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Eugene Kapun <abacabadabacaba@gmail.com>
Cc: reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] reiserfs: make extended attributes support more
	configurable
Message-ID: <20090709183220.GA6371@infradead.org>
References: <4A56313D.1020304@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A56313D.1020304@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 09, 2009 at 10:04:45PM +0400, Eugene Kapun wrote:
> From: Eugene Kapun <abacabadabacaba@gmail.com>
> 
> Adds configuration options which control how reiserfs supports extended
> attributes. This makes support for POSIX ACLs and security labels
> independent on support for normal xattrs. This also makes possible to
> compile reiserfs without any xattrs support.

There's absoutely no reason for adding even more horrible ifdef churn.

