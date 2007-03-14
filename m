Return-Path: <linux-kernel-owner+w=401wt.eu-S1030857AbXCNNvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030857AbXCNNvz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 09:51:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933919AbXCNNvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 09:51:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49162 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933915AbXCNNvx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 09:51:53 -0400
Date: Wed, 14 Mar 2007 14:51:52 +0100
From: Nick Piggin <npiggin@suse.de>
To: Linux Filesystems <linux-fsdevel@vger.kernel.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mark Fasheh <mark.fasheh@oracle.com>
Subject: Re: [patch 1/5] fs: add an iovec iterator
Message-ID: <20070314135152.GB5103@wotan.suse.de>
References: <20070314112529.13798.35417.sendpatchset@linux.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070314112529.13798.35417.sendpatchset@linux.site>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2007 at 02:38:12PM +0100, Nick Piggin wrote:
> Add an iterator data structure to operate over an iovec. Add usercopy
> operators needed by generic_file_buffered_write, and convert that function
> over.

Just a note to anyone looking at these -- they don't apply to any tree,
and I'm posting them at this stage mainly to get feedback on the a_ops
APIs. Comments from anyone welcome.

