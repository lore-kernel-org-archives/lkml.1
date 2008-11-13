Return-Path: <linux-kernel-owner+w=401wt.eu-S1755694AbYKMXSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694AbYKMXSv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 18:18:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751598AbYKMXSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 18:18:42 -0500
Received: from fms-01.valinux.co.jp ([210.128.90.1]:51202 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751143AbYKMXSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 18:18:42 -0500
Date: Fri, 14 Nov 2008 08:18:40 +0900 (JST)
Message-Id: <20081114.081840.114538392.taka@valinux.co.jp>
To: psusi@cfl.rr.com
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com, fernando@oss.ntt.co.jp,
       balbir@linux.vnet.ibm.com, xemul@openvz.org,
       kamezawa.hiroyu@jp.fujitsu.com, agk@sourceware.org
Subject: Re: [dm-devel] [PATCH 1/8] dm-ioband: Introduction
From: Hirokazu Takahashi <taka@valinux.co.jp>
In-Reply-To: <491C81CB.7010705@cfl.rr.com>
References: <20081113.121019.104237699577193919.ryov@valinux.co.jp>
	<20081113.121146.623571555980959797.ryov@valinux.co.jp>
	<491C81CB.7010705@cfl.rr.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Ryo Tsuruta wrote:
> > Create two ioband devices "ioband1" and "ioband2". "ioband1" is mapped
> > to "/dev/sda1" and has a weight of 40. "ioband2" is mapped to "/dev/sda2"
> > and has a weight of 10. "ioband1" can use 80% --- 40/(40+10)*100 ---
> > of the bandwidth of the physical disk "/dev/sda" while "ioband2" can use 20%.
> 
> Just to clarify, when you say ioband1 can use 80% of the bandwidh, you 
> mean that is how much it will get if both io bands are loaded right?  If 
> there is no activity on ioband2, then ioband1 will get the full disk 
> bandwidth right?

Absolutely, you are right!

Thank you,
Hirokazu Takahashi.
