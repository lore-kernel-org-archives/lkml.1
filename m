Return-Path: <linux-kernel-owner+w=401wt.eu-S1751755AbYJQHKH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751755AbYJQHKH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 03:10:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753633AbYJQHJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 03:09:52 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:35949 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753604AbYJQHJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 03:09:51 -0400
Date: Fri, 17 Oct 2008 16:09:50 +0900 (JST)
Message-Id: <20081017.160950.71109894.ryov@valinux.co.jp>
To: agk@redhat.com, linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com
Cc: fernando@oss.ntt.co.jp
Subject: [PATCH 0/2] dm-ioband: I/O bandwidth controller v1.8.0:
 Introduction
From: Ryo Tsuruta <ryov@valinux.co.jp>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alasdair and all,

This is the dm-ioband version 1.8.0 release.

Dm-ioband is an I/O bandwidth controller implemented as a device-mapper
driver, which gives specified bandwidth to each job running on the same
physical device.

This release is a minor bug fix and confirmed running on the latest
stable kernel 2.6.27.1.

- Can be applied to the kernel 2.6.27.1 and 2.6.27-rc5-mm1.
- Changes from 1.7.0 (posted on Oct 3, 2008):
  - Fix a minor bug in io_limit setting that causes dm-ioband to stop
    issuing I/O requests when a large value is set to io_limit.

Alasdair, could you please review this patch and give me any comments?

Thanks,
Ryo Tsuruta
