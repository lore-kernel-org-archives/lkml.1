Return-Path: <linux-kernel-owner+w=401wt.eu-S1755628AbYJMBeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628AbYJMBeq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 21:34:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754353AbYJMBei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 21:34:38 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:54984 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754310AbYJMBeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 21:34:37 -0400
Date: Sun, 12 Oct 2008 19:34:21 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Peter Chubb <peterc@gelato.unsw.edu.au>
Cc: jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [patch] fix 64-vbit prefetchable memory resource BARs
Message-ID: <20081013013421.GS25780@parisc-linux.org>
References: <8763nx1fr3.wl%peter@chubb.wattle.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8763nx1fr3.wl%peter@chubb.wattle.id.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2008 at 11:49:04AM +1100, Peter Chubb wrote:
> This patch checks only for the PCI_BASE_ADDRESS_MEM_TYPE_64 bit; thus
> whether the region is prefetchable or not is ignored.  This fixes my
> Infiniband.

Sorry about that.

> Signed-off-by: Peter Chubb <peterc@gelato.unsw.edu.au>

Reviewed-by: Matthew Wilcox <willy@linux.intel.com>

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
