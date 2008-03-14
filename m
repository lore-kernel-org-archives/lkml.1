Return-Path: <linux-kernel-owner+w=401wt.eu-S1758373AbYCNSPL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758373AbYCNSPL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 14:15:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753316AbYCNSO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 14:14:59 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51479 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbYCNSO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 14:14:58 -0400
Date: Fri, 14 Mar 2008 14:14:55 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Carlo Wood <carlo@alinoe.com>, ext3grep@googlegroups.com,
       linux-kernel@vger.kernel.org
Subject: Re: [ext3grep] compile error
Message-ID: <20080314181455.GA15351@infradead.org>
References: <1f45affd0803140826m34d9eee5veb8069e215d55fcf@mail.gmail.com> <20080314170004.GA25174@alinoe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080314170004.GA25174@alinoe.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2008 at 06:00:04PM +0100, Carlo Wood wrote:
> This seem a bug in linux/ext3_fs.h. I was able to reproduce this on
> debian sid, meaning kernel (headers) 2.6.24.

No, the problem is that the tool you're compiling is using kernel
headers which it shouldn't use at all.  Please use the headers from
e2fslibs-dev in /usr/include/esxt2fs/ instead.  And yes, they provide
ext3 defintions despite the ext2 name.

The only kernel todo here is to remove ext3*.h from the list of exported
headers ASAP.
