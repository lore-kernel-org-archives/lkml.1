Return-Path: <linux-kernel-owner+w=401wt.eu-S1757901AbYESIWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757901AbYESIWs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 04:22:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754621AbYESIWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 04:22:40 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:54487 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751839AbYESIWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 04:22:39 -0400
Date: Mon, 19 May 2008 17:22:38 +0900 (JST)
Message-Id: <20080519.172238.193709851.ryov@valinux.co.jp>
To: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com
Cc: agk@sourceware.org
Subject: [PATCH 0/2] dm-ioband: I/O bandwidth controller v1.0.0:
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

This is dm-ioband version 1.0.0 release.

Dm-ioband is an I/O bandwidth controller implemented as a device-mapper
driver, which gives specified bandwidth to each job running on the same
physical device.

- Can be applied to the kernel 2.6.26-rc2-mm1.
- Changes from 0.0.4 (24th April):
    - Performance tuning
      - A new bandwidth control policy is added. This policy controls
        bandwidth based on the number of I/O sectors instead of the
	number of I/O requests.
	I think it would be useful for some applications such as video
	streaming or when you want to use high-end storages.
       - Control read and write requests separately. So even if a
         write I/O queue in an elevator is full, read I/O requests
	 won't be blocked.
      - More accurate bandwidth control.
    - Code cleanups. Remove the "LINUX_VERSION_CODE" and "inline" stuff.
    - Fix panic on "dmsetup suspend."

For more details, please refer to:
http://people.valinux.co.jp/~ryov/dm-ioband/

Thanks,
Ryo Tsuruta
