Return-Path: <linux-kernel-owner+w=401wt.eu-S1755018AbYKLV3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018AbYKLV3v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 16:29:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752459AbYKLV3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 16:29:42 -0500
Received: from xenotime.net ([72.52.64.118]:36666 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752070AbYKLV3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 16:29:41 -0500
Date: Wed, 12 Nov 2008 13:29:05 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, a.zummo@towertech.it
Subject: Re: mmotm 2008-11-10-14-54 uploaded (RTC)
Message-Id: <20081112132905.289e9c69.rdunlap@xenotime.net>
In-Reply-To: <200811102254.mAAMsTU5029697@imap1.linux-foundation.org>
References: <200811102254.mAAMsTU5029697@imap1.linux-foundation.org>
Organization: YPO4
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


drivers/rtc/rtc-dev.c contains 2 duplicated switch cases:

mmotm-2008-1112-1148/drivers/rtc/rtc-dev.c: In function 'rtc_dev_ioctl':
mmotm-2008-1112-1148/drivers/rtc/rtc-dev.c:421: error: duplicate case value
mmotm-2008-1112-1148/drivers/rtc/rtc-dev.c:372: error: previously used here
mmotm-2008-1112-1148/drivers/rtc/rtc-dev.c:426: error: duplicate case value
mmotm-2008-1112-1148/drivers/rtc/rtc-dev.c:368: error: previously used here

---
~Randy
