Return-Path: <linux-kernel-owner+w=401wt.eu-S1161512AbXBOWSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161512AbXBOWSs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 17:18:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161478AbXBOWSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 17:18:47 -0500
Received: from ftp.linux-mips.org ([194.74.144.162]:51412 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161508AbXBOWSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 17:18:46 -0500
Date: Thu, 15 Feb 2007 22:18:39 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Optimize generic get_unaligned / put_unaligned implementations.
Message-ID: <20070215221839.GA14103@linux-mips.org>
References: <20050830104056.GA4710@linux-mips.org> <20060306.203218.69025300.nemoto@toshiba-tops.co.jp> <20060306170552.0aab29c5.akpm@osdl.org> <20070214214226.GA17899@linux-mips.org> <20070214203903.8d013170.akpm@linux-foundation.org> <20070215143441.GA18155@linux-mips.org> <20070215135358.020781dd.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070215135358.020781dd.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 15, 2007 at 01:53:58PM -0800, Andrew Morton wrote:

> > The whole union thing was only needed to get rid of a warning but Marcel's
> > solution does the same thing by attaching the packed keyword to the entire
> > structure instead, so this patch is now using his macros but using __packed
> > instead.
> 
> How do we know this trick will work as-designed across all versions of gcc
> and icc (at least) and for all architectures and for all sets of compiler
> options?
> 
> Basically, it has to be guaranteed by a C standard.  Is it?

Gcc info page says:

[...]
`packed'
     The `packed' attribute specifies that a variable or structure field
     should have the smallest possible alignment--one byte for a
     variable, and one bit for a field, unless you specify a larger
     value with the `aligned' attribute.
[...]

Qed?

  Ralf
