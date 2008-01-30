Return-Path: <linux-kernel-owner+w=401wt.eu-S1755272AbYA3DcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272AbYA3DcT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 22:32:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752122AbYA3DcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 22:32:07 -0500
Received: from fms-01.valinux.co.jp ([210.128.90.1]:53962 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751392AbYA3DcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 22:32:05 -0500
Date: Wed, 30 Jan 2008 12:32:02 +0900 (JST)
Message-Id: <20080130.123202.189729685.ryov@valinux.co.jp>
To: inakoshi.hiroya@jp.fujitsu.com
Cc: containers@lists.linux-foundation.org, dm-devel@redhat.com,
       xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org
Subject: Re: [Xen-devel] dm-band: The I/O bandwidth controller: Performance
 Report
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <479ECAC9.5070709@jp.fujitsu.com>
References: <20080123.215350.193721890.ryov@valinux.co.jp>
	<20080125.160720.183032233.ryov@valinux.co.jp>
	<479ECAC9.5070709@jp.fujitsu.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> you mean that you run 128 processes on each user-device pairs?  Namely,
> I guess that
> 
>   user1: 128 processes on sdb5,
>   user2: 128 processes on sdb5,
>   another: 128 processes on sdb5,
>   user2: 128 processes on sdb6.

"User-device pairs" means "band groups", right?
What I actually did is the followings:

  user1: 128 processes on sdb5,
  user2: 128 processes on sdb5,
  user3: 128 processes on sdb5,
  user4: 128 processes on sdb6.

> The second preliminary studies might be:
> - What if you use a different I/O size on each device (or device-user pair)?
> - What if you use a different number of processes on each device (or
> device-user pair)?

There are other ideas of controlling bandwidth, limiting bytes-per-sec,
latency time or something. I think it is possible to implement it if 
a lot of people really require it. I feel there wouldn't be a single
correct answer for this issue. Posting good ideas how it should work
and submitting patches for it are also welcome.

> And my impression is that it's natural dm-band is in device-mapper,
> separated from I/O scheduler.  Because bandwidth control and I/O
> scheduling are two different things, it may be simpler that they are
> implemented in different layers.

I would like to know how dm-band works on various configurations on
various type of hardware. I'll try running dm-band on with other
configurations. Any reports or impressions of dm-band on your machines
are also welcome.

Thanks,
Ryo Tsuruta
