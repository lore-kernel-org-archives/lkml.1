Return-Path: <linux-kernel-owner+w=401wt.eu-S1753443AbYKNBiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443AbYKNBiT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 20:38:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751497AbYKNBiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 20:38:07 -0500
Received: from fms-01.valinux.co.jp ([210.128.90.1]:57412 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751488AbYKNBiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 20:38:04 -0500
Date: Fri, 14 Nov 2008 10:38:28 +0900 (JST)
Message-Id: <20081114.103828.737004071327928691.ryov@valinux.co.jp>
To: dm-devel@redhat.com, taka@valinux.co.jp
Cc: psusi@cfl.rr.com, xen-devel@lists.xensource.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, agk@sourceware.org,
       xemul@openvz.org, fernando@oss.ntt.co.jp,
       kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com
Subject: Re: [dm-devel] [PATCH 1/8] dm-ioband: Introduction
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <20081114.081840.114538392.taka@valinux.co.jp>
References: <20081113.121146.623571555980959797.ryov@valinux.co.jp>
	<491C81CB.7010705@cfl.rr.com>
	<20081114.081840.114538392.taka@valinux.co.jp>
X-Mailer: Mew version 6.1 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Phillip,

> > Ryo Tsuruta wrote:
> > > Create two ioband devices "ioband1" and "ioband2". "ioband1" is mapped
> > > to "/dev/sda1" and has a weight of 40. "ioband2" is mapped to "/dev/sda2"
> > > and has a weight of 10. "ioband1" can use 80% --- 40/(40+10)*100 ---
> > > of the bandwidth of the physical disk "/dev/sda" while "ioband2" can use 20%.
> > 
> > Just to clarify, when you say ioband1 can use 80% of the bandwidh, you 
> > mean that is how much it will get if both io bands are loaded right?  If 
> > there is no activity on ioband2, then ioband1 will get the full disk 
> > bandwidth right?
> 
> Absolutely, you are right!

Here is a benchmark result of sharing bandwidth between three ioband
devices. When there is no activity on ioband2, the total bandwidth of
the disk is shared only between ioband1 and ioband3 according to their
weights.
http://people.valinux.co.jp/~ryov/dm-ioband/benchmark/partition1.html

--
Ryo Tsuruta <ryov@valinux.co.jp>
