Return-Path: <linux-kernel-owner+w=401wt.eu-S1755377AbYKLVlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377AbYKLVlQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 16:41:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752249AbYKLVlB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 16:41:01 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44622 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752181AbYKLVlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 16:41:00 -0500
Date: Wed, 12 Nov 2008 13:40:33 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-kernel@vger.kernel.org, a.zummo@towertech.it
Subject: Re: mmotm 2008-11-10-14-54 uploaded (RTC)
Message-Id: <20081112134033.35c70911.akpm@linux-foundation.org>
In-Reply-To: <20081112132905.289e9c69.rdunlap@xenotime.net>
References: <200811102254.mAAMsTU5029697@imap1.linux-foundation.org>
	<20081112132905.289e9c69.rdunlap@xenotime.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Nov 2008 13:29:05 -0800
Randy Dunlap <rdunlap@xenotime.net> wrote:

> 
> drivers/rtc/rtc-dev.c contains 2 duplicated switch cases:
> 
> mmotm-2008-1112-1148/drivers/rtc/rtc-dev.c: In function 'rtc_dev_ioctl':
> mmotm-2008-1112-1148/drivers/rtc/rtc-dev.c:421: error: duplicate case value
> mmotm-2008-1112-1148/drivers/rtc/rtc-dev.c:372: error: previously used here
> mmotm-2008-1112-1148/drivers/rtc/rtc-dev.c:426: error: duplicate case value
> mmotm-2008-1112-1148/drivers/rtc/rtc-dev.c:368: error: previously used here
> 

Thanks.  rtc-add-alarm-update-irq-interfaces.patch is incompatible with
rtc-rtc-wm8350-add-support-for-wm8350-rtc.patch.  I'll drop
rtc-add-alarm-update-irq-interfaces.patch.
