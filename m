Return-Path: <linux-kernel-owner+w=401wt.eu-S1760958AbYFIMz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760958AbYFIMz7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 08:55:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758138AbYFIMzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 08:55:48 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:40942 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757545AbYFIMzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 08:55:47 -0400
Date: Mon, 9 Jun 2008 06:55:30 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Maxim Shchetynin <maxim@linux.vnet.ibm.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: AZFS file system proposal
Message-ID: <20080609125530.GF30405@parisc-linux.org>
References: <20080609104650.4f220492@mercedes-benz.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080609104650.4f220492@mercedes-benz.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2008 at 10:46:50AM +0200, Maxim Shchetynin wrote:
> +config AZ_FS
> +	tristate "AZFS filesystem support"
> +	help
> +	  Non-buffered filesystem for block devices with a gendisk and
> +	  with direct_access() method in gendisk->fops.
> +	  AZFS does not buffer outgoing traffic and is doing no read ahead.
> +	  It supports mount options (given with -o) bs=x,uid=x,gid=x.
> +	  If block-size (bs) is not specified AZFS uses block-size used
> +	  by block device. Though mmap() method is available only if
> +	  block-size equals to or is greater than system page size.

This is a terrible description.  I can't even suggest better wording
because I don't understand it.  The correct wording would not mention
gendisks, fops or direct_access().  It would tell the user what they
might use it for.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
