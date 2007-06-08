Return-Path: <linux-kernel-owner+w=401wt.eu-S1757590AbXFHOfN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757590AbXFHOfN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 10:35:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754127AbXFHOe6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 10:34:58 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:38031 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753944AbXFHOe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 10:34:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=ZilHky9nPYiyF55UGxn1tdbKKYEaU1ptvNm7LIyh2YWu33UfEcswjv3l6679Nsy1/NwlK/HCv5Dmide9inkTQsR8BPFpXZPFSera7LVdeXgr70mDpCRAh/P0NCquc9I+tWtJ65L/kEDP5yNZ+ROqxvuJdwY0JXsRmc9AIDZaQvs=
Message-ID: <64d833020706080734n282940fey7081481745af3765@mail.gmail.com>
Date: Fri, 8 Jun 2007 10:34:56 -0400
From: koan <koan00@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: RE: [patch 29/32] NET: Fix race condition about network device name allocation.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I get a compilation failure from the patch:

  CC      net/core/stream.o
  CC      net/core/scm.o
  CC      net/core/gen_stats.o
  CC      net/core/gen_estimator.o
  CC      net/core/sysctl_net_core.o
  CC      net/core/dev.o
net/core/dev.c: In function 'netdev_run_todo':
net/core/dev.c:3155: error: 'struct net_device' has no member named 'dev'
make[2]: *** [net/core/dev.o] Error 1
make[1]: *** [net/core] Error 2
make: *** [net] Error 2


Thanks, Jesse

(I am not on list, please CC me with replies)
