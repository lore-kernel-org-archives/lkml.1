Return-Path: <linux-kernel-owner+w=401wt.eu-S1755193AbYJVIGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193AbYJVIGT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 04:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754560AbYJVIFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 04:05:41 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:57576 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755077AbYJVIFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 04:05:37 -0400
Date: Wed, 22 Oct 2008 17:05:36 +0900 (JST)
Message-Id: <20081022.170536.193712541.ryov@valinux.co.jp>
To: zumeng.chen@windriver.com
Cc: bruce.ashfield@windriver.com, haotian.zhang@windriver.com,
       linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com, fernando@oss.ntt.co.jp
Subject: Re: [PATCH 0/2] dm-ioband: I/O bandwidth controller v1.8.0:
 Introduction
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <48FEDC63.308@windriver.com>
References: <20081017.160950.71109894.ryov@valinux.co.jp>
	<48FDB8AC.9020707@windriver.com>
	<48FEDC63.308@windriver.com>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chen,

> Chen Zumeng wrote:
> > Hi, Ryo Tsuruta
> > And our test team want to test bio_tracking as your benchmark reports,
> > so would you please send me your test codes? Thanks in advance.
> Hi Ryo Tsuruta,
> 
> I wonder if you received last email, so I reply this email to ask
> for your bio_tracking test codes to generate your benchmark reports
> as shown in your website. Thanks in advance :)

I've uploaded two scripts here:
http://people.valinux.co.jp/~ryov/dm-ioband/scripts/xdd-count.sh
http://people.valinux.co.jp/~ryov/dm-ioband/scripts/xdd-size.sh

xdd-count.sh controls bandwidth based on the number of I/O requests,
and xdd-size.sh controls bandwidth based onthe number of I/O sectors.
Theses scritpts require xdd disk I/O testing tool which can be
downloaded from here:
http://www.ioperformance.com/products.htm

Please feel free to ask me questions if you have any questions.

> > P.S. The following are my changes to avoid schedule_timeout:

Thanks, but your patch seems to cause a problem when ioband devices
which have the same name are created at the same time. I will fix the
issue in the next release.

Thanks,
Ryo Tsuruta
