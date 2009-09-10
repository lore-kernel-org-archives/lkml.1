Return-Path: <linux-kernel-owner+w=401wt.eu-S1753850AbZIJDpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850AbZIJDpq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 23:45:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752447AbZIJDpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 23:45:45 -0400
Received: from mail.valinux.co.jp ([210.128.90.3]:50879 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170AbZIJDpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 23:45:45 -0400
Date: Thu, 10 Sep 2009 12:45:47 +0900 (JST)
Message-Id: <20090910.124547.71116284.ryov@valinux.co.jp>
To: vgoyal@redhat.com
Cc: riel@redhat.com, linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       jens.axboe@oracle.com, agk@redhat.com, akpm@linux-foundation.org,
       nauman@google.com, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       balbir@linux.vnet.ibm.com
Subject: Re: Regarding dm-ioband tests
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <20090909143159.GC8256@redhat.com>
References: <20090908134244.GA15974@redhat.com>
	<20090909.190146.59669568.ryov@valinux.co.jp>
	<20090909143159.GC8256@redhat.com>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,

Vivek Goyal <vgoyal@redhat.com> wrote:
> > In addition,
> > there are devices which doesn't use standard IO schedulers, and
> > dm-ioband can work on even such devices.
> 
> This is a interesting use case. Few thoughts.
> 
> - Can't io scheduling mechanism of these devices make use of elevator and
>   elevator fair queuing interfaces to take advantage of io controlling
>   mechanism. It should not be too difficult. Look at noop. It has
>   just 131 lines of code and it now supports hierarchical io scheduling.
>  
>   This will come with request queue and its merging and plug/unplug
>   mechanism. Is that an issue?
>
> - If not, then yes, for these corner cases, io scheduler based controller
>   does not work as it is.

I have a extreme fast SSD and its device driver provides its own
make_request_fn(). So the device driver intercepts IO requests and the
subsequent processes are done within it.

Thanks,
Ryo Tsuruta
