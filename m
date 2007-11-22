Return-Path: <linux-kernel-owner+w=401wt.eu-S1753540AbXKVLGC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540AbXKVLGC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 06:06:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751870AbXKVLFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 06:05:50 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:38575 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085AbXKVLFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 06:05:49 -0500
Date: Thu, 22 Nov 2007 11:05:45 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, sam@ravnborg.org
Subject: Re: [PATCH RFC] [1/9] Core module symbol namespaces code and intro.
Message-ID: <20071122110545.GA4552@infradead.org>
References: <20071122343.446909000@suse.de> <200711221456.22297.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711221456.22297.rusty@rustcorp.com.au>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 22, 2007 at 02:56:22PM +1100, Rusty Russell wrote:
>     This is an interesting idea, thanks for the code!  My only question is 
> whether we can get most of this benefit by dropping the indirection of 
> namespaces and have something like "EXPORT_SYMBOL_TO(sym, modname)"?  It
> doesn't work so well for exporting to a group of modules, but that seems
> a reasonable line to draw anyway.

I'd say exporting to a group of modules is the main use case.  E.g. in
scsi there would be symbols exported to transport class modules only
or lots of the vfs_ symbols would be exported only to stackable filesystems
or nfsd.

