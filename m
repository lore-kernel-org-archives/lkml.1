Return-Path: <linux-kernel-owner+w=401wt.eu-S1754417AbZBIBWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417AbZBIBWQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 20:22:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753719AbZBIBWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 20:22:00 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:54743 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635AbZBIBV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 20:21:59 -0500
Date: Sun, 8 Feb 2009 18:21:40 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Julia Lawall <julia@diku.dk>
Cc: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 4/6] drivers/pci: introduce missing kfree
Message-ID: <20090209012140.GJ31509@parisc-linux.org>
References: <Pine.LNX.4.64.0902082244490.25891@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0902082244490.25891@ask.diku.dk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 08, 2009 at 10:45:24PM +0100, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Error handling code following a kmalloc should free the allocated data.
> Since the subsequent code that could provoke an error does not use the
> allocated data, the allocation is just moved below it.
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>

Reviewed-by: Matthew Wilcox <willy@linux.intel.com>

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
