Return-Path: <linux-kernel-owner+w=401wt.eu-S1753604AbZIHDXF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604AbZIHDXF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 23:23:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753576AbZIHDXC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 23:23:02 -0400
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:57960 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639AbZIHDW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 23:22:58 -0400
Date: Tue, 8 Sep 2009 08:52:55 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: riel@redhat.com, vgoyal@redhat.com, linux-kernel@vger.kernel.org,
       dm-devel@redhat.com, jens.axboe@oracle.com, agk@redhat.com,
       akpm@linux-foundation.org, nauman@google.com,
       guijianfeng@cn.fujitsu.com, jmoyer@redhat.com
Subject: Re: Regarding dm-ioband tests
Message-ID: <20090908032254.GJ8315@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090904231129.GA3689@redhat.com>
 <20090907.200222.193693062.ryov@valinux.co.jp>
 <4AA51065.6050000@redhat.com>
 <20090908.120119.71095369.ryov@valinux.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090908.120119.71095369.ryov@valinux.co.jp>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ryo Tsuruta <ryov@valinux.co.jp> [2009-09-08 12:01:19]:

> I think there are some advantages to dm-ioband. That's why I post
> dm-ioband to the mailing list.
> 
> - dm-ioband supports not only proportional weight policy but also rate
>   limiting policy. Besides, new policies can be added to dm-ioband if
>   a user wants to control bandwidth by his or her own policy.
> - The dm-ioband driver can be replaced without stopping the system by
>   using device-mapper's facility. It's easy to maintain.
> - dm-ioband can use without cgroup. (I remember Vivek said it's not an
>   advantage.)

But don't you need page_cgroup for IO tracking?

-- 
	Balbir
