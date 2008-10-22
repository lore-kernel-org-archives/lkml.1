Return-Path: <linux-kernel-owner+w=401wt.eu-S1756596AbYJVKiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596AbYJVKiu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 06:38:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755931AbYJVKid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 06:38:33 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:52586 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756242AbYJVKic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 06:38:32 -0400
Date: Wed, 22 Oct 2008 19:38:31 +0900 (JST)
Message-Id: <20081022.193831.193716981.ryov@valinux.co.jp>
To: zumeng.chen@windriver.com
Cc: agk@redhat.com, linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com, fernando@oss.ntt.co.jp
Subject: Re: [PATCH 0/2] dm-ioband: I/O bandwidth controller v1.8.0:
 Introduction
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <48FDB8AC.9020707@windriver.com>
References: <20081017.160950.71109894.ryov@valinux.co.jp>
	<48FDB8AC.9020707@windriver.com>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chen,

> I applied your patches(both) into the latest kernel(27), and dm-ioband
> looks work well(other than schedule_timeout in alloc_ioband_device);
> But I think you are the author of bio_tracking, so it is high
> appreciated if you can give your comments and advices for potential
> difference between 27-rc5-mm1 and 2.6.27 to me.

There is no major difference between both version, but I have no time
to port and test bio-cgroup to/on 2.6.27.

Kamezawa-san said
> the newest mmotm has the newest *big* change. enjoy it ;)

The next bio-cgroup patch will be based on this newest change.

Thanks,
Ryo Tsuruta
