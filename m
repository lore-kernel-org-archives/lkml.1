Return-Path: <linux-kernel-owner+w=401wt.eu-S1755786Ab0ASVSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755786Ab0ASVSY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 16:18:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755630Ab0ASVSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 16:18:20 -0500
Received: from kroah.org ([198.145.64.141]:53473 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932125Ab0ASVSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 16:18:18 -0500
Date: Tue, 19 Jan 2010 12:59:12 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: manual merge of the driver-core tree with Linus'
 tree
Message-ID: <20100119205912.GA10928@kroah.com>
References: <20100118184956.ea783994.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100118184956.ea783994.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 18, 2010 at 06:49:56PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the driver-core tree got a conflict in
> drivers/base/memory.c between commit
> 8ff410daa009c4b44be445ded5b0cec00abc0426 ("sysdev: fix prototype for
> memory_sysdev_class show/store functions") from Linus' tree and commits
> 95f4918fb2826dd7fc7be8a375ee0b71e8276a62 ("sysdev: Fix type of sysdev
> class attribute in memory driver") and
> 18a994bc1df640e77b853af5b6a175d6871b449f ("driver-core: Add attribute
> argument to class_attribute show/store") from the driver-core tree.
> 
> Not a big suprise.  I fixed it up by using the driver-core tree version
> (effectively reverting the version in Linus' tree).

I've fixed this up in my tree now.

thanks,

greg k-h
