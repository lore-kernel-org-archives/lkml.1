Return-Path: <linux-kernel-owner+w=401wt.eu-S1755834AbYJWL3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834AbYJWL3A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 07:29:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752748AbYJWL2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 07:28:52 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:55093 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752710AbYJWL2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 07:28:52 -0400
Date: Thu, 23 Oct 2008 20:28:51 +0900 (JST)
Message-Id: <20081023.202851.112594221.ryov@valinux.co.jp>
To: haotian.zhang@windriver.com
Cc: zumeng.chen@windriver.com, bruce.ashfield@windriver.com,
       linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com, fernando@oss.ntt.co.jp
Subject: Re: [PATCH 0/2] dm-ioband: I/O bandwidth controller v1.8.0:
 Introduction
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <1224756158.8286.36.camel@pek-hzhang-d1>
References: <48FEDC63.308@windriver.com>
	<20081022.170536.193712541.ryov@valinux.co.jp>
	<1224756158.8286.36.camel@pek-hzhang-d1>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Haotian,

> The results are almost the same. I can not see any change of Direct I/O
> performance for this bio-cgroup kernel feature with dm-ioband support!
> 
> Does the methord to caculate throughout should be the Rate of xdd.linux
> output? 
> Dose my testing approach should be correct? If not, please help me point
> out.

Could you try to run the xdd programs simultaneously?
dm-ioband controls bandwidth while I/O requests are issued
simultaneously from processes which belong to different cgroup.
If I/O requests are only issued from processes which belong to one
cgroup, the processes can use the whole bandwidth.

The following URL is an example of how bandwidth is shared to I/O
load change.
http://people.valinux.co.jp/~ryov/dm-ioband/benchmark/partition1.html

Thanks,
Ryo Tsuruta
