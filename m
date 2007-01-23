Return-Path: <linux-kernel-owner+w=401wt.eu-S932903AbXAWPm3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932903AbXAWPm3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 10:42:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932939AbXAWPm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 10:42:29 -0500
Received: from stout.engsoc.carleton.ca ([134.117.69.22]:60762 "EHLO
	stout.engsoc.carleton.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932903AbXAWPm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 10:42:27 -0500
Date: Tue, 23 Jan 2007 10:42:02 -0500
From: Kyle McMartin <kyle@parisc-linux.org>
To: Yu-Chen Wu <g944370@oz.nthu.edu.tw>
Cc: "'Anton Altaparmakov'" <aia21@cam.ac.uk>, linux-kernel@vger.kernel.org
Subject: Re: Could convert a buffer that allocated by vmalloc to pages?
Message-ID: <20070123154202.GA8892@athena.road.mcmartin.ca>
References: <030701c73eef$0b4d0010$0100a8c0@sslabmayasky> <1169557944.4475.8.camel@imp.csi.cam.ac.uk> <030801c73ef8$f2198a00$0100a8c0@sslabmayasky>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <030801c73ef8$f2198a00$0100a8c0@sslabmayasky>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 23, 2007 at 10:15:33PM +0800, Yu-Chen Wu wrote:
> printk(KERN_INFO "vmalloc_to_page tpage :%x\n",tpage);
> //===========info of dmesg==================
<snip>
> [ 1561.768492] page allocated:60ea9000
> [ 1561.768497] vmalloc_to_page tpage :7fcf7e18
> 
> Why the page address get from vmalloc_to_page is different with the first
> page address of the vm_struct (73d65000)?
> 

Memory returned by vmalloc is only virtually contiguous, not physically
contiguous. If you're allocating memory for DMA, see the interface
documented in Documentation/DMA-mapping.txt for more information.

-- Kyle
