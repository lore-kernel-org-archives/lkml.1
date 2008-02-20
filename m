Return-Path: <linux-kernel-owner+w=401wt.eu-S1763622AbYBTRHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763622AbYBTRHX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 12:07:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753941AbYBTRGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 12:06:37 -0500
Received: from mx0.towertech.it ([213.215.222.73]:48496 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754918AbYBTRGf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 12:06:35 -0500
Date: Wed, 20 Feb 2008 18:03:25 +0100
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: rtc-linux@googlegroups.com
Cc: galak@kernel.crashing.org, LKML Kernel <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>, rz@linux-m68k.org
Subject: Re: [rtc-linux] state of GEN_RTC vs rtc subsystem
Message-ID: <20080220180325.46446675@i1501.lan.towertech.it>
In-Reply-To: <47B18612-66A3-476C-B81C-F2FD11CE9A64@kernel.crashing.org>
References: <47B18612-66A3-476C-B81C-F2FD11CE9A64@kernel.crashing.org>
Organization: Tower Technologies
X-Mailer: Sylpheed
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2008 10:11:23 -0600
Kumar Gala <galak@kernel.crashing.org> wrote:

> 
> Is the functionality provided by drivers/char/gen_rtc.c completely  
> handled by the rtc subsystem in drivers/rtc?
> 
> I ask for two reasons:
> 1. should we make it mutually exclusive in Kconfig
> 2. I've enabled both and get (we'll my defconfig did):

 They shouldn't be enabled at once. I think a patch 
 for Kconfig has been recently submitted to give a warning
 in such a case.

 rtc-cmos should be able to handle the vast majority of x86
 rtcs out there. 

 The only real open issue is related to the ntp synchronization
 mode and will be solved only when we can get rid of it :)

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

