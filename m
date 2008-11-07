Return-Path: <linux-kernel-owner+w=401wt.eu-S1753898AbYKGCjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898AbYKGCjm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 21:39:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750806AbYKGCje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 21:39:34 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57313 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750733AbYKGCjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 21:39:33 -0500
Message-ID: <4913A9C2.8060904@cn.fujitsu.com>
Date: Fri, 07 Nov 2008 10:36:50 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: vgoyal@redhat.com
CC: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org, jens.axboe@oracle.com,
       Hirokazu Takahashi <taka@valinux.co.jp>,
       Ryo Tsuruta <ryov@valinux.co.jp>, Andrea Righi <righi.andrea@gmail.com>,
       Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, fernando@oss.ntt.co.jp,
       balbir@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       menage@google.com, ngupta@google.com, Rik van Riel <riel@redhat.com>,
       Jeff Moyer <jmoyer@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 0/4] [RFC] Another proportional weight IO controller
References: <20081106153022.215696930@redhat.com>
In-Reply-To: <20081106153022.215696930@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vgoyal@redhat.com wrote:
> Hi,
> 
> If you are not already tired of so many io controller implementations, here
> is another one.
> 
> This is a very eary very crude implementation to get early feedback to see
> if this approach makes any sense or not.
> 
> This controller is a proportional weight IO controller primarily
> based on/inspired by dm-ioband. One of the things I personally found little
> odd about dm-ioband was need of a dm-ioband device for every device we want
> to control.  I thought that probably we can make this control per request
> queue and get rid of device mapper driver. This should make configuration
> aspect easy.
> 
> I have picked up quite some amount of code from dm-ioband especially for
> biocgroup implementation.
> 
> I have done very basic testing and that is running 2-3 dd commands in different
> cgroups on x86_64. Wanted to throw out the code early to get some feedback.
> 
> More details about the design and how to are in documentation patch.
> 
> Your comments are welcome.

  Which kernel version is this patch set based on?

> 
> Thanks
> Vivek
> 

-- 
Regards
Gui Jianfeng

