Return-Path: <linux-kernel-owner+w=401wt.eu-S1760137AbXIVJ0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760137AbXIVJ0Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 05:26:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751493AbXIVJ0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 05:26:17 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35521 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252AbXIVJ0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 05:26:16 -0400
Date: Sat, 22 Sep 2007 10:26:14 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Andi Kleen <ak@suse.de>
Cc: jblunck@suse.de, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [24/45] x86: Introduce frame_pointer() and stack_pointer()
Message-ID: <20070922092613.GA27827@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Andi Kleen <ak@suse.de>, jblunck@suse.de, patches@x86-64.org,
	linux-kernel@vger.kernel.org
References: <200709211044.901175000@suse.de> <20070921204506.65C9F14EFF@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070921204506.65C9F14EFF@wotan.suse.de>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2007 at 10:45:06PM +0200, Andi Kleen wrote:
> From: jblunck@suse.de
> This patch defines frame_pointer() and stack_pointer() similar to the
> already defined instruction_pointer(). Thus the oprofile code can be written
> in a more readable fashion.

Can we do these for all architectures, please?  They're quite useful for
non-trivial kprobes.

