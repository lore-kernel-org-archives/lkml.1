Return-Path: <linux-kernel-owner+w=401wt.eu-S1760643AbXI0XZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760643AbXI0XZl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 19:25:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759473AbXI0XZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 19:25:21 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51721 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759365AbXI0XZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 19:25:19 -0400
Date: Thu, 27 Sep 2007 16:11:10 -0700
From: Greg KH <greg@kroah.com>
To: Kyle Moffett <mrmacman_g4@mac.com>
Cc: Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Jens Axboe <jens.axboe@oracle.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] fs: Correct SuS compliance for open of large file
	without options
Message-ID: <20070927231110.GB869@kroah.com>
References: <20070927143548.GT5243@kernel.dk> <20070927154432.302ec5a7@the-village.bc.nu> <20070927150853.GA10154@kernel.dk> <20070927161912.2f08aff6@the-village.bc.nu> <20070927155902.GA6450@thunk.org> <20070927102343.1a113ccc.akpm@linux-foundation.org> <20070927175917.GB8339@kroah.com> <20070927183742.GA23734@thunk.org> <20070927213445.GA7857@kroah.com> <0A83B4BA-9D5E-4003-AE58-8ED0B4E1243C@mac.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0A83B4BA-9D5E-4003-AE58-8ED0B4E1243C@mac.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2007 at 06:27:48PM -0400, Kyle Moffett wrote:
> On Sep 27, 2007, at 17:34:45, Greg KH wrote:
>> On Thu, Sep 27, 2007 at 02:37:42PM -0400, Theodore Tso wrote:
>>> That fact that sysfs is all laid out in a directory, but for which some 
>>> directories/symlinks are OK to use, and some are NOT OK to use --- is why 
>>> I call the sysfs interface "an open pit".
>>
>> And because of the original design mistakes, we have only been able to 
>> change things for the better in a slow manner.  We have had userspace 
>> programs fixed up for _years_ before we are able to make the corresponding 
>> changes in the kernel, so as to not break the distros that are slow to 
>> upgrade packages and kernels (like Debian.)
>
> Hey!  No poking fingers at Debian here; it's been *MUCH* improved lately.  

Heh, sorry, but Debian in the past had a lot of problems in this area.
It's good to know that this is no longer a issue :)

thanks,

greg k-h
