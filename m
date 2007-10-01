Return-Path: <linux-kernel-owner+w=401wt.eu-S1756182AbXJAQss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182AbXJAQss (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 12:48:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752676AbXJAQsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 12:48:41 -0400
Received: from cantor.suse.de ([195.135.220.2]:40659 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751657AbXJAQsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 12:48:40 -0400
From: Andi Kleen <andi@firstfloor.org>
Organization: -
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] [24/45] x86: Introduce frame_pointer() and stack_pointer()
Date: Mon, 1 Oct 2007 18:48:36 +0200
User-Agent: KMail/1.9.6
Cc: jblunck@suse.de, patches@x86-64.org, linux-kernel@vger.kernel.org
References: <200709211044.901175000@suse.de> <20070921204506.65C9F14EFF@wotan.suse.de> <20070922092613.GA27827@infradead.org>
In-Reply-To: <20070922092613.GA27827@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710011848.36855.andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 22 September 2007 11:26:14 Christoph Hellwig wrote:
> On Fri, Sep 21, 2007 at 10:45:06PM +0200, Andi Kleen wrote:
> > From: jblunck@suse.de
> > This patch defines frame_pointer() and stack_pointer() similar to the
> > already defined instruction_pointer(). Thus the oprofile code can be written
> > in a more readable fashion.
> 
> Can we do these for all architectures, please?  They're quite useful for
> non-trivial kprobes.

I'll leave that to the architecture maintainers. Besides many probably
don't have a frame pointer.

-Andi



