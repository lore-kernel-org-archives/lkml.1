Return-Path: <linux-kernel-owner+w=401wt.eu-S1757663AbZFZIqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757663AbZFZIqq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 04:46:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756578AbZFZIqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 04:46:37 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:57747 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753516AbZFZIqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 04:46:36 -0400
Date: Fri, 26 Jun 2009 17:46:39 +0900 (JST)
Message-Id: <20090626.174639.193685940.ryov@valinux.co.jp>
To: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com, centos@centos.org
Subject: dm-ioband RPM packages
From: Ryo Tsuruta <ryov@valinux.co.jp>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I'm pleased to announce that the new dm-ioband RPM package (v1.12.0)
has been released at:
  http://sourceforge.net/apps/trac/ioband/wiki/dm-ioband

dm-ioband provides disk bandwidth control on per partition, per user,
per process and per virtual machine (such as KVM or Xen) basis.

The RPM packages are for Red Hat Enterprise Linux 5.x and CentOS
5.x. They were tested on RHEL 5.2 and CentOS 5.3 and will also work on
other 5.x versions.

The major change of this release is that a new bandwidth control
policy "range-bw" is supported. This policy is developed by Dong-Jae
Kang, and it allows users to set a minimum and maximum I/O bandwidth
by absolute numbers. The minimum I/O bandwidth should be guaranteed
for stable performance or reliability of specific process groups, and
I/O bandwidth over the maximum limit should be throttled to protect
the limited I/O resource from over-provisioning in unnecessary usage
or to reserve the I/O bandwidth for another use.

Please visit our website for more information.
  http://sourceforge.net/apps/trac/ioband/wiki/dm-ioband

Any comments and suggestions are welcome!

Thanks,
Ryo Tsuruta
