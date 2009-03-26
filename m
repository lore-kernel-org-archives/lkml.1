Return-Path: <linux-kernel-owner+w=401wt.eu-S1753778AbZCZFMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778AbZCZFMR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 01:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752400AbZCZFL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 01:11:59 -0400
Received: from m50-135.163.com ([123.125.50.135]:55046 "HELO m50-135.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752324AbZCZFL6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 01:11:58 -0400
X-Greylist: delayed 911 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Mar 2009 01:11:57 EDT
Date: Thu, 26 Mar 2009 12:55:29 +0800
From: "ideawu" <ideawu@163.com>
To: "bfields" <bfields@fieldses.org>
Cc: "nfsv4@linux-nfs.org" <nfsv4@linux-nfs.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: [PATCH]sunrpc/svc.c: Remove unused line 'rqstp->rq_server = serv;' in svc_process
Message-ID: <200903261255292962249@163.com>
X-mailer: Foxmail 6, 14, 103, 24 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: D9GowLALYXv_CstJDBIkGQ--.35898S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUUYxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb5xYjxAI64sEg-sGvwAYjxAI6xAIw28IcVW8ZrWlb7IF0VCF04k2
	0xvEw2I207IF0wAYjxAI6xCIbckI1I0E57IF64kEYxAxM7k0a2IF6r1UM7kC6x804xWl14
	x267AKxVWUJVW8JwAFxVCF77xC6IxKo4kEV4yl1I0EscIYIxCEI4klw4CSwwAFIxvE14AK
	wVWUJVWUGwA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxV
	AFwI0_GcCE3s1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAF
	wI0_GcCE3s1ln4vEbcI7uVAqrcv_JFW8Xr15Mc804VCqF7xvr2I5Mc02F40EFcxC0VAKzV
	Aqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lF7xv
	r2IYc2Ij64vIr41lFVAaXTZC67ZELSn0mTvEwaV2v3VFvVW8Mx02cVAKzwCY02Avz4vE14
	v_Grylc2IjII80xcxEwVW8JVW5JwCF04k20xvY0x0EwIxGrwCF72vE52k0Y41lx4CE17CE
	b7AF67AKxVWUXVWUAwCIc40Y0x0EwIxGrwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I
	8E87Iv6xkF7I0E14v26r1j6r4UMs8CjcxG0xvEn4CqF7xvrbIYCTnIWIevJa73UjIFyTuY
	vjxUwlksDUUUU
X-CM-SenderInfo: 5lght4rx6rljoofrz/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to set rqstp->rq_server to serv, while serv is initialized as rqstp->rq_server at previous line. And between these two lines, there is no change to rqstp->rq_server.

Signed-off-by: ideawu <ideawu@163.com>
--------

--- net/sunrpc/svc.c	2009-03-24 07:12:14.000000000 +0800
+++ net/sunrpc/svc.mod.c	2009-03-26 09:39:15.187500000 +0800
@@ -1093,7 +1093,6 @@ svc_process(struct svc_rqst *rqstp)
 	procp = versp->vs_proc + proc;
 	if (proc >= versp->vs_nproc || !procp->pc_func)
 		goto err_bad_proc;
-	rqstp->rq_server   = serv;
 	rqstp->rq_procinfo = procp;



