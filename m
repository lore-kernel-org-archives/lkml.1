Return-Path: <linux-kernel-owner+w=401wt.eu-S1754028AbZAFJVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028AbZAFJVi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 04:21:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751647AbZAFJVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 04:21:21 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:38415 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475AbZAFJVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 04:21:20 -0500
Date: Tue, 6 Jan 2009 04:21:14 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: ebiederm@xmission.com, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org,
       sds@tycho.nsa.gov, jmorris@namei.org
Subject: Re: [PATCH 1/6] proc: implement support for automounts in task
	directories
Message-ID: <20090106092114.GA11877@infradead.org>
References: <20090105233241.GA3924@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090105233241.GA3924@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2009 at 02:32:41AM +0300, Alexey Dobriyan wrote:
> This is current version of /proc/net as separate file system patchset,
> rebased, etc. I'll put it into -next again when merge window closes.

I still don't see the point for that.  Why not /proc/nets/<netid> with
symlinks from /proc/<pid>/net into those?

