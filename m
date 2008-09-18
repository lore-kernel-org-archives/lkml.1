Return-Path: <linux-kernel-owner+w=401wt.eu-S1755280AbYIRME2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280AbYIRME2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 08:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753156AbYIRMEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 08:04:20 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:59720 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753107AbYIRMET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 08:04:19 -0400
Date: Thu, 18 Sep 2008 21:04:18 +0900 (JST)
Message-Id: <20080918.210418.226794540.ryov@valinux.co.jp>
Subject: dm-ioband + bio-cgroup benchmarks
From: Ryo Tsuruta <ryov@valinux.co.jp>
To: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com
Cc: agk@sourceware.org, balbir@linux.vnet.ibm.com, xemul@openvz.org,
       kamezawa.hiroyu@jp.fujitsu.com, fernando@oss.ntt.co.jp
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I have got excellent results of dm-ioband, that controls the disk I/O
bandwidth even when it accepts delayed write requests.

In this time, I ran some benchmarks with a high-end storage. The
reason was to avoid a performance bottleneck due to mechanical factors
such as seek time.

You can see the details of the benchmarks at:
http://people.valinux.co.jp/~ryov/dm-ioband/hps/

Thanks,
Ryo Tsuruta
