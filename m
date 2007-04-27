Return-Path: <linux-kernel-owner+w=401wt.eu-S1755748AbXD0Mje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755748AbXD0Mje (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 08:39:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755763AbXD0Mje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 08:39:34 -0400
Received: from mail.clusterfs.com ([206.168.112.78]:42266 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755748AbXD0Mjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 08:39:32 -0400
Message-ID: <4631EEFE.7060309@clusterfs.com>
Date: Fri, 27 Apr 2007 18:09:26 +0530
From: Manoj Joseph <manoj@clusterfs.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Marat Buharov <marat.buharov@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Mike Galbraith <efault@gmx.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Subject: Re: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when
 FS is under heavy write load (massive starvation)
References: <1177660767.6567.41.camel@Homer.simpson.net>	 <20070427013350.d0d7ac38.akpm@linux-foundation.org> <698310e10704270459t7663d39dp977cf055b8db9d2a@mail.gmail.com>
In-Reply-To: <698310e10704270459t7663d39dp977cf055b8db9d2a@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Marat Buharov wrote:
> On 4/27/07, Andrew Morton <akpm@linux-foundation.org> wrote:
>> Aside: why the heck do applications think that their data is so important
>> that they need to fsync it all the time.  I used to run a kernel on my
>> laptop which had "return 0;" at the top of fsync() and fdatasync().  Most
>> pleasurable.
> 
> So, if having fake fsync() and fdatasync() is pleasurable for laptop
> and desktop, may be it's time to add option into Kconfig which
> disables normal fsync behaviour in favor of robust desktop?

Sure, a noop fsync/fdatasync would speed up some things. And I am sure 
Andrew Morton knew what he was doing and the consequences.

But unless you care nothing about your data, you should not do it. It is 
as simple as that. No, it does not give you a robust desktop!!

-Manoj

-- 
Manoj Joseph
http://kerneljunkie.blogspot.com/
