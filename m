Return-Path: <linux-kernel-owner+w=401wt.eu-S1755828Ab0ASVSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828Ab0ASVSc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 16:18:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755795Ab0ASVS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 16:18:29 -0500
Received: from kroah.org ([198.145.64.141]:53508 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755794Ab0ASVS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 16:18:26 -0500
Date: Tue, 19 Jan 2010 13:14:22 -0800
From: Greg KH <greg@kroah.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Sachin Sant <sachinp@in.ibm.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org
Subject: Re: [-next Jan 18] Boot failure on s390 with DEVTMPFS=y
Message-ID: <20100119211422.GA10319@kroah.com>
References: <20100118195743.b45f119e.sfr@canb.auug.org.au>
 <4B546E7B.2080900@in.ibm.com>
 <ac3eb2511001180631r5209dff6s83ecdaee708e0b0b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac3eb2511001180631r5209dff6s83ecdaee708e0b0b@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 18, 2010 at 03:31:09PM +0100, Kay Sievers wrote:
> On Mon, Jan 18, 2010 at 15:21, Sachin Sant <sachinp@in.ibm.com> wrote:
> > Today next (next-20100118) failed to boot on a s390 box
> > with the following Oops :
> 
> > Unable to handle kernel pointer dereference at virtual kernel address
> > 0000000000543000
> 
> > <00000000001eb5da> shmem_fill_super+0x13a/0x25c
> > <0000000000228cfa> get_sb_single+0xbe/0xdc
> > <000000000034ffc0> dev_get_sb+0x2c/0x38
> > <000000000066c602> devtmpfs_init+0x46/0xc0
> 
> > Previous next builds worked fine on the same box. The only difference
> > between configs of the two builds was CONFIG_DEVTMPFS. This option was
> > enabled while compiling 20100118.
> 
> Heiko Carstens posted a simple patch to work around the issue that
> s390 write-protects the string, the option parser tries to modify.
> When Greg has pick it up, this should be fixed.

Yes, I've now queued it up in my trees.

thanks,

greg k-h
