Return-Path: <linux-kernel-owner+w=401wt.eu-S1756253AbYJNJNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253AbYJNJNb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 05:13:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754695AbYJNJNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 05:13:22 -0400
Received: from smtp-out.neti.ee ([194.126.126.37]:32995 "EHLO smtp-out.neti.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754581AbYJNJNV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 05:13:21 -0400
X-Greylist: delayed 762 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Oct 2008 05:13:21 EDT
Message-ID: <48F45FA5.6040308@liewenthal.ee>
Date: Tue, 14 Oct 2008 12:00:21 +0300
From: =?ISO-8859-1?Q?J=FCri_Reitel?= <juri.reitel@liewenthal.ee>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: invalid default values in RTC chip
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

My question relates to RTC driver linux/drivers/rtc/rtc-ds1307.c for 
device m41t00. Driver probe function will fail if some of the chip's 
registers contain invalid date time values i.e. if month register is 32 
or minutes is 61. Is this correct behavior? Probe function's purpose is 
to check if the device is as was assumed (this time RTC and it is). The 
chip's values are incorrect but the chip works, even the m41t00 chip 
manual states that after initial powerup (RTC battery power applied) 
internal registers will contain random data.

There are two solutions first is driver patch and another is i2c-dev and 
i2cset tool to use from user space during bootup. Whitch one should be used?

PS. please add me to CC also.

JR
