Return-Path: <linux-kernel-owner+w=401wt.eu-S1755367AbZDPM4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367AbZDPM4l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 08:56:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753133AbZDPM4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 08:56:32 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:58703 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752695AbZDPM4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 08:56:31 -0400
Date: Thu, 16 Apr 2009 21:56:30 +0900 (JST)
Message-Id: <20090416.215630.183034963.ryov@valinux.co.jp>
To: vgoyal@redhat.com
Cc: dm-devel@redhat.com, vivek.goyal2008@gmail.com,
       linux-kernel@vger.kernel.org, agk@redhat.com
Subject: Re: [dm-devel] Re: dm-ioband: Test results.
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <20090415170415.GE15067@redhat.com>
References: <20090413144626.GF18007@redhat.com>
	<20090414.183022.71120459.ryov@valinux.co.jp>
	<20090415170415.GE15067@redhat.com>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,

> How does your ioband setup looks like. Have you created at least one more
> competing ioband device? Because I think only in that case you have got
> this ad-hoc logic of waiting for the group which has not finished the
> tokens yet and you will end up buffering the bio in a FIFO.

I created two ioband devices and ran the dd commands only on the first
device.

> Do let me know if you think there is something wrong with my
> configuration.

>From a quick look at your configuration, there seems to be no problem.

> Can you also send bio-cgroup patches which apply to 2.6.30-rc1 so that
> I can do testing for async writes.

I've just posted the patches to related mailing lists. Please try it.

> Why have you split the regular patch and bio-cgroup patch? Do you want
> to address only reads and sync writes?

For the first step, my goal is to merge dm-ioband into device-mapper,
and bio-cgroup is not necessary for all situations such as bandwidth
control on a per partition basis.

I'll also try to do more test and report you back.

Thank you for your help,
Ryo Tsuruta
