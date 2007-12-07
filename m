Return-Path: <linux-kernel-owner+w=401wt.eu-S1754241AbXLGMDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241AbXLGMDS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 07:03:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751332AbXLGMDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 07:03:08 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42403 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751246AbXLGMDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 07:03:07 -0500
Date: Fri, 7 Dec 2007 04:02:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Shane <gnome42@gmail.com>
Cc: linux-kernel@vger.kernel.org, Trond Myklebust <trond.myklebust@fys.uio.no>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.24-rc3-git4 NFS crossmnt regression
Message-Id: <20071207040219.e231cbc7.akpm@linux-foundation.org>
In-Reply-To: <fa4052ef0712062045o743a2666u3562a3569c1aa989@mail.gmail.com>
References: <fa4052ef0712062045o743a2666u3562a3569c1aa989@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Dec 2007 23:45:58 -0500 Shane <gnome42@gmail.com> wrote:

> Hi,
> 
> The NFS crossmnt/nohide feature has been working beautifully
> in 2.6.23. NFS in general has been really good in 2.6.23. Thanks!
> 
> However, starting in  2.6.24-rc3-git4, I immediately get 'NFS Stale
> file handle' messages for any accesses to the NFS crossmnt'ed
> volumes. Regular NFS mounts are fine but the crossmnt'ed
> subdirs return only that error message.
> 
> 2.6.24-rc3-git1 is last known good kernel. The problem also exists
> with the latest snap 2.6.24-rc4-git4. NFS server is 2.6.23-rc9 and
> is unchanged.

hm, there have been no nfs changes since 2.6.24-rc4.

> It is easily reproducible here, hopefully for the person who
> knows how to debug it too :)
> 

I guess a full set of the commands which you typed to reproduce this would
help.

Rafael, please add to the post-2.6.23 regression list?  (If there's any
room left).

Thanks.
