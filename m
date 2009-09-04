Return-Path: <linux-kernel-owner+w=401wt.eu-S933744AbZIDQZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933744AbZIDQZc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 12:25:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933686AbZIDQZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 12:25:30 -0400
Received: from mx0.towertech.it ([213.215.222.73]:45381 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933695AbZIDQZ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 12:25:29 -0400
Date: Fri, 4 Sep 2009 18:25:28 +0200
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: rtc-linux@googlegroups.com
Cc: mjg@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [rtc-linux] [PATCH 2/2] rtc: Add boot_timesource sysfs
 attribute
Message-ID: <20090904182528.591dbd29@i1501.lan.towertech.it>
In-Reply-To: <1252081568-6000-2-git-send-email-mjg@redhat.com>
References: <1252081568-6000-1-git-send-email-mjg@redhat.com>
	<1252081568-6000-2-git-send-email-mjg@redhat.com>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  4 Sep 2009 12:26:08 -0400
Matthew Garrett <mjg@redhat.com> wrote:

> CONFIG_RTC_HCTOSYS allows the kernel to read the system time from the RTC
> at boot and resume, avoiding the need for userspace to do so. Unfortunately
> userspace currently has no way to know whether this configuration option
> is enabled and thus cannot sensibly choose whether to run hwclock itself or
> not. Add a boot_timesource sysfs attribute which indicates whether a given
> RTC set the system clock.

 This feature is meant to be in addition of the regular
 hwclock call to read the system time.

 Have you tested if there are drawbacks by not reading it? Like
 TZ, DST and similar?

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

