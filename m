Return-Path: <linux-kernel-owner+w=401wt.eu-S1753339AbZLUMhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339AbZLUMhh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 07:37:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753271AbZLUMhd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 07:37:33 -0500
Received: from verein.lst.de ([213.95.11.210]:47643 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756730AbZLUMha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 07:37:30 -0500
Date: Mon, 21 Dec 2009 13:37:27 +0100
From: Christoph Hellwig <hch@lst.de>
To: Liuwenyi <qingshenlwy@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 00/12]posix_acl: Add the check items
Message-ID: <20091221123654.GA9201@lst.de>
References: <4B2F6153.8010609@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B2F6153.8010609@gmail.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I like taking these checks into posix_acl_valid, but I think the patch
submission needs a bit more work.

All the patches are extremly whitespace mangled.  And I don't think
splitting them up makes a whole lot of sense, when we do API changes
like this we usually fix up all callers.  So please try to fix your
mailer, merged them all into one, and maybe also chose a more
descriptive subject line, e.g.

Subject: take checks for NULL and error pointers into posix_acl_valid()


And btw, at least the XFS change seems incorrect - previously we
returned NULL acl pointer and this patch changes it to -EINVAL.

