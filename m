Return-Path: <linux-kernel-owner+w=401wt.eu-S1762809AbXKPS1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762809AbXKPS1Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 13:27:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753370AbXKPS1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 13:27:00 -0500
Received: from koto.vergenet.net ([210.128.90.7]:39698 "EHLO koto.vergenet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752741AbXKPS1A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 13:27:00 -0500
Date: Fri, 16 Nov 2007 10:26:51 -0800
From: Simon Horman <horms@verge.net.au>
To: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
Cc: lkml <linux-kernel@vger.kernel.org>, kexec-ml <kexec@lists.infradead.org>
Subject: Re: [PATCH 1/5] Rename vmcoreinfo's macros returning the size
Message-ID: <20071116182646.GA8971@verge.net.au>
References: <473CFE14.3010400@mxs.nes.nec.co.jp> <473D015E.4030908@mxs.nes.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <473D015E.4030908@mxs.nes.nec.co.jp>
User-Agent: mutt-ng/devel-r804 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2007 at 11:33:02AM +0900, Ken'ichi Ohmichi wrote:
> 
> VMCOREINFO_SIZE() should be renamed VMCOREINFO_STRUCT_SIZE() since it's always
> returning the size of the struct with a given name. This change would allow
> VMCOREINFO_TYPEDEF_SIZE() to simply become VMCOREINFO_SIZE() since it need not
> be used exclusively for typedefs.
> 
> This discussion is the following:
> http://www.ussg.iu.edu/hypermail/linux/kernel/0709.3/0582.html
> 
> Signed-off-by: Ken'ichi Ohmichi <oomichi@mxs.nes.nec.co.jp>
> Acked-by: David Rientjes <rientjes@google.com>

As far as name changes go, this one looks good to me.

Acked-by: Simon Horman <horms@verge.net.au>
