Return-Path: <linux-kernel-owner+w=401wt.eu-S1762388AbYGBGZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762388AbYGBGZX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 02:25:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757867AbYGBGZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 02:25:12 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60384 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754822AbYGBGZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 02:25:11 -0400
Message-ID: <486B1EE0.9060303@cn.fujitsu.com>
Date: Wed, 02 Jul 2008 14:23:28 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [-mmotm] some different buliding failures
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


drivers/mfd/sm501.c:39: error: field 'gpio' has incomplete type


drivers/media/video/ivtv/ivtv-ioctl.c: In function 'ivtv_set_funcs':
drivers/media/video/ivtv/ivtv-ioctl.c:1899: error: 'struct video_device' has no member named 'vidioc_g_register'
drivers/media/video/ivtv/ivtv-ioctl.c:1900: error: 'struct video_device' has no member named 'vidioc_s_register'


mm/hugetlb.c: In function 'vma_needs_reservation':
mm/hugetlb.c:859: error: implicit declaration of function 'vma_pagecache_offset'
