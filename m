Return-Path: <linux-kernel-owner+w=401wt.eu-S1752402AbXCMXks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402AbXCMXks (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 19:40:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbXCMXks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 19:40:48 -0400
Received: from wr-out-0506.google.com ([64.233.184.239]:21572 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbXCMXkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 19:40:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Irs2yS3pK+V2SrzALKRSAERy5/74qk0qjhCv+xi9E74b6wl+vfc6Q9aNe5Iv9CQzW1gowrdYCYOAQzXvnIguk/Mb2u8SweWlSkMcV987ApxdZBA3eQLaNUtQ3OLNMv3M85eATBDZsfH0MNzPhSHzqYuJpnxkwI6JqdeW0jpE/68=
Message-ID: <f2b55d220703131640p47f441cdk6f213e64eb78f2e3@mail.gmail.com>
Date: Tue, 13 Mar 2007 16:40:41 -0700
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "Christoph Hellwig" <hch@infradead.org>,
       "Michael K. Edwards" <medwards.linux@gmail.com>,
       "David Miller" <davem@davemloft.net>, alan@lxorguk.ukuu.org.uk,
       7eggert@gmx.de, dada1@cosmosbay.com, linux-kernel@vger.kernel.org
Subject: Re: sys_write() racy for multi-threaded append?
In-Reply-To: <20070313190949.GA3417@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f2b55d220703121746k1a849b78rec3131cb6f5eae38@mail.gmail.com>
	 <20070313022430.57503b08@lxorguk.ukuu.org.uk>
	 <f2b55d220703130025l48ea2e8ci15ddf0563cf21bf9@mail.gmail.com>
	 <20070313.004224.41634994.davem@davemloft.net>
	 <f2b55d220703130924h11786d9fh1d87f90bcd1b3d60@mail.gmail.com>
	 <f2b55d220703131059j2b47b3e0s1edae6150929684f@mail.gmail.com>
	 <20070313190949.GA3417@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/13/07, Christoph Hellwig <hch@infradead.org> wrote:
> Michael, please stop spreading this utter bullshit _now_.  You're so
> full of half-knowledge that it's not funny anymore, and you try
> to insult people knowing a few magniutes more than you left and right.

Thank you Christoph for that informative response to my comments.  I
take it that you consider read_write.c to be code of the highest
quality and maintainability.  If you have something specific in mind
when you write "utter bullshit" and "half-knowledge", I'd love to hear
it.

Now, for those who still care to respond as if improving the kernel
were a goal that you and I can share, a question:  When
generic_file_llseek needs the inode in order to retrieve the current
file size, it goes through f_mapping (the pagecache entry?) rather
than through f_path.dentry (the dentry cache?).  All other inode
retrievals in read_write.c go through f_path.dentry.  Why?  Or is this
a question that can only be asked on linux-fsdevel?

Cheers,
- Michael
