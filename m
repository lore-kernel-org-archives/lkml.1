Return-Path: <linux-kernel-owner+w=401wt.eu-S1752905AbYJCFh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905AbYJCFh7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 01:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752693AbYJCFhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 01:37:50 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:47368 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752204AbYJCFhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 01:37:50 -0400
Date: Fri, 03 Oct 2008 14:37:49 +0900 (JST)
Message-Id: <20081003.143749.193701570.ryov@valinux.co.jp>
To: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com
Cc: fernando@oss.ntt.co.jp, balbir@linux.vnet.ibm.com, xemul@openvz.org,
       kamezawa.hiroyu@jp.fujitsu.com, agk@sourceware.org
Subject: [PATCH 0/2] dm-ioband: I/O bandwidth controller v1.7.0:
 Introduction
From: Ryo Tsuruta <ryov@valinux.co.jp>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

This is the dm-ioband version 1.7.0 release.

Dm-ioband is an I/O bandwidth controller implemented as a device-mapper
driver, which gives specified bandwidth to each job running on the same
physical device.

- Can be applied to the kernel 2.6.27-rc5-mm1.
- Changes from 1.6.0 (posted on Sep 24, 2008):
  - Fix a problem that processes issuing I/Os are permanently blocked
    when I/O requests to reclaim pages are consecutively issued.

You can apply the latest bio-cgroup patch to this dm-ioband version.
The bio-cgroup provides a BIO tracking mechanism with dm-ioband.
Please see the following site for more information:
  Block I/O tracking
  http://people.valinux.co.jp/~ryov/bio-cgroup/

Thanks,
Ryo Tsuruta
