Return-Path: <linux-kernel-owner+w=401wt.eu-S1757874AbYKMTsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757874AbYKMTsW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 14:48:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755114AbYKMTgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 14:36:51 -0500
Received: from exhub016-3.exch016.msoutlookonline.net ([207.5.72.226]:9436
	"EHLO EXHUB016-3.exch016.msoutlookonline.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755504AbYKMTgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 14:36:51 -0500
Message-ID: <491C81CB.7010705@cfl.rr.com>
Date: Thu, 13 Nov 2008 14:36:43 -0500
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: device-mapper development <dm-devel@redhat.com>
CC: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com, fernando@oss.ntt.co.jp,
       balbir@linux.vnet.ibm.com, xemul@openvz.org,
       kamezawa.hiroyu@jp.fujitsu.com, agk@sourceware.org
Subject: Re: [dm-devel] [PATCH 1/8] dm-ioband: Introduction
References: <20081113.121019.104237699577193919.ryov@valinux.co.jp> <20081113.121146.623571555980959797.ryov@valinux.co.jp>
In-Reply-To: <20081113.121146.623571555980959797.ryov@valinux.co.jp>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ryo Tsuruta wrote:
> Create two ioband devices "ioband1" and "ioband2". "ioband1" is mapped
> to "/dev/sda1" and has a weight of 40. "ioband2" is mapped to "/dev/sda2"
> and has a weight of 10. "ioband1" can use 80% --- 40/(40+10)*100 ---
> of the bandwidth of the physical disk "/dev/sda" while "ioband2" can use 20%.

Just to clarify, when you say ioband1 can use 80% of the bandwidh, you 
mean that is how much it will get if both io bands are loaded right?  If 
there is no activity on ioband2, then ioband1 will get the full disk 
bandwidth right?

