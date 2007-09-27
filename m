Return-Path: <linux-kernel-owner+w=401wt.eu-S1759834AbXI0W2J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759834AbXI0W2J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 18:28:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758603AbXI0W15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 18:27:57 -0400
Received: from smtpoutm.mac.com ([17.148.16.77]:53639 "EHLO smtpoutm.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758595AbXI0W14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 18:27:56 -0400
In-Reply-To: <20070927213445.GA7857@kroah.com>
References: <20070927070118.2bd4792e@laptopd505.fenrus.org> <20070927151921.29b19abb@the-village.bc.nu> <20070927143548.GT5243@kernel.dk> <20070927154432.302ec5a7@the-village.bc.nu> <20070927150853.GA10154@kernel.dk> <20070927161912.2f08aff6@the-village.bc.nu> <20070927155902.GA6450@thunk.org> <20070927102343.1a113ccc.akpm@linux-foundation.org> <20070927175917.GB8339@kroah.com> <20070927183742.GA23734@thunk.org> <20070927213445.GA7857@kroah.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <0A83B4BA-9D5E-4003-AE58-8ED0B4E1243C@mac.com>
Cc: Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Jens Axboe <jens.axboe@oracle.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [PATCH] fs: Correct SuS compliance for open of large file	without options
Date: Thu, 27 Sep 2007 18:27:48 -0400
To: Greg KH <greg@kroah.com>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 27, 2007, at 17:34:45, Greg KH wrote:
> On Thu, Sep 27, 2007 at 02:37:42PM -0400, Theodore Tso wrote:
>> That fact that sysfs is all laid out in a directory, but for which  
>> some directories/symlinks are OK to use, and some are NOT OK to  
>> use --- is why I call the sysfs interface "an open pit".
>
> And because of the original design mistakes, we have only been able  
> to change things for the better in a slow manner.  We have had  
> userspace programs fixed up for _years_ before we are able to make  
> the corresponding changes in the kernel, so as to not break the  
> distros that are slow to upgrade packages and kernels (like Debian.)

Hey!  No poking fingers at Debian here; it's been *MUCH* improved  
lately.  I far more frequently have problems with boxes still running  
some ancient release of RHEL-4 or something than I do with those  
running Debian stable (virtually always the latest Debian stable).

Cheers,
Kyle Moffett

