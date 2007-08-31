Return-Path: <linux-kernel-owner+w=401wt.eu-S965475AbXHaPgF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965475AbXHaPgF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 11:36:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758106AbXHaPfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 11:35:54 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:9802 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757790AbXHaPfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 11:35:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=JJOjIy2iscvaPBDi49QywJD7k8HGz1fHd3QiBtNf5a9Siu/E4x4I/376a8Ycj6sExTutr+jdyCXd/hq021BEytnJOvbdX+ShgHio3rbovGCjpEdCAZqZeNsIgvSuwi57C7R+XiYpe5tg8BN2cNM2L5Ztb9e97ZW2pL5GVXLBqGk=
Message-ID: <46D8354A.3030208@googlemail.com>
Date: Fri, 31 Aug 2007 17:35:38 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, "CK Mailinglist" <ck@vds.kolivas.org>
Subject: [ANNOUNCE] DeskOpt - on fly task, i/o scheduler optimization
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is something that might be useful for gamers and audio/video editors
http://www.stardust.webpages.pl/files/tools/deskopt/

You can easily tune CFS/CFQ scheduler params

sched_batch_wakeup_granularity_ns
sched_latency_ns
sched_min_granularity_ns
sched_runtime_limit_ns
sched_stat_granularity_ns
sched_wakeup_granularity_ns

back_seek_max
back_seek_penalty
fifo_expire_async
fifo_expire_sync
quantum
slice_async
slice_async_rq
slice_idle
slice_sync

+ nice levels

Results from Nexuiz benchmark

|-------------------------------------------------------------------------------------------|
|	                                      |    CFS + CFQ 	  |   CFS + CFQ + DeskOpt * |
|-------------------------------------------------------------------------------------------|
| timedemo demos/demo2                        |	41,395896833 fps  |   41,460051233 fps      |
| timedemo demos/demo2 + massive_intr 4 1000  |	18,343223633 fps  |   37,814504933 fps      |
| timedemo demos/demo2 + massive_intr 8 1000  |	9,334974533 fps   |   37,376611267 fps      |
|-------------------------------------------------------------------------------------------|

* default class for games

DeskOpt has many design flaws, but it works for me :)

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
