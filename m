Return-Path: <linux-kernel-owner+w=401wt.eu-S1756355AbZEVIzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756355AbZEVIzQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 04:55:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752664AbZEVIzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 04:55:05 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62127 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751920AbZEVIzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 04:55:03 -0400
Message-ID: <4A166829.6070608@cn.fujitsu.com>
Date: Fri, 22 May 2009 16:54:01 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       jens.axboe@oracle.com, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       righi.andrea@gmail.com, agk@redhat.com, dm-devel@redhat.com,
       snitzer@redhat.com, m-ikeda@ds.jp.nec.com, akpm@linux-foundation.org
Subject: Re: [PATCH 04/18] io-controller: Modify cfq to make use of flat elevator
 fair queuing
References: <1241553525-28095-1-git-send-email-vgoyal@redhat.com> <1241553525-28095-5-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1241553525-28095-5-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,

Since thinking time logic is moving to common layer, corresponding items
in cic is not needed.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
diff --git a/include/linux/iocontext.h b/include/linux/iocontext.h
index ed52a1f..1fe9d78 100644
--- a/include/linux/iocontext.h
+++ b/include/linux/iocontext.h
@@ -42,10 +42,6 @@ struct cfq_io_context {
 	unsigned long last_end_request;
 	sector_t last_request_pos;
 
-	unsigned long ttime_total;
-	unsigned long ttime_samples;
-	unsigned long ttime_mean;
-
 	unsigned int seek_samples;
 	u64 seek_total;
 	sector_t seek_mean;



