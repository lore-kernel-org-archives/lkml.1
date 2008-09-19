Return-Path: <linux-kernel-owner+w=401wt.eu-S1757089AbYISIrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757089AbYISIrl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 04:47:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750977AbYISIrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 04:47:33 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:39902 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbYISIrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 04:47:32 -0400
Message-ID: <48D36794.6010002@oss.ntt.co.jp>
Date: Fri, 19 Sep 2008 17:49:24 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Ryo Tsuruta <ryov@valinux.co.jp>
CC: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com, fernando@oss.ntt.co.jp,
       balbir@linux.vnet.ibm.com, xemul@openvz.org,
       kamezawa.hiroyu@jp.fujitsu.com, agk@sourceware.org
Subject: Re: dm-ioband + bio-cgroup benchmarks
References: <20080918.210418.226794540.ryov@valinux.co.jp>
In-Reply-To: <20080918.210418.226794540.ryov@valinux.co.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tsuruta-san,

Ryo Tsuruta wrote:
> Hi All,
> 
> I have got excellent results of dm-ioband, that controls the disk I/O
> bandwidth even when it accepts delayed write requests.
> 
> In this time, I ran some benchmarks with a high-end storage. The
> reason was to avoid a performance bottleneck due to mechanical factors
> such as seek time.
> 
> You can see the details of the benchmarks at:
> http://people.valinux.co.jp/~ryov/dm-ioband/hps/
> 

I took a look at your beautiful results!
When you have time, would you explain me how you succeeded to check the
time, bandwidth, especially when you did write() tests? Actually, I tried
similar tests and failed to check the bandwidth correctly. Did you insert
something in the kernel source?

Thanks,
Takuya Yoshikawa
