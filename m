Return-Path: <linux-kernel-owner+w=401wt.eu-S1760664AbXI0X3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760664AbXI0X3Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 19:29:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754726AbXI0X27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 19:28:59 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:59854 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759285AbXI0X27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 19:28:59 -0400
Date: Thu, 27 Sep 2007 17:28:57 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Theodore Tso <tytso@mit.edu>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Jens Axboe <jens.axboe@oracle.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] fs: Correct SuS compliance for open of large file without options
Message-ID: <20070927232857.GA12049@parisc-linux.org>
References: <20070927143548.GT5243@kernel.dk> <20070927154432.302ec5a7@the-village.bc.nu> <20070927150853.GA10154@kernel.dk> <20070927161912.2f08aff6@the-village.bc.nu> <20070927155902.GA6450@thunk.org> <20070927102343.1a113ccc.akpm@linux-foundation.org> <20070927175917.GB8339@kroah.com> <20070927183742.GA23734@thunk.org> <20070927213445.GA7857@kroah.com> <20070927231927.GE8688@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070927231927.GE8688@thunk.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2007 at 07:19:27PM -0400, Theodore Tso wrote:
> Would you accept a patch which causes the deprecated sysfs
> files/directories to disappear, even if CONFIG_SYS_DEPRECATED is
> defined, via a boot-time parameter?

How about a mount option?  That way people can test without a reboot:

mount -o remount,deprecated={yes,no} /sys

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
