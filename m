Return-Path: <linux-kernel-owner+w=401wt.eu-S1753630Ab0AWHbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630Ab0AWHbp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 02:31:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752380Ab0AWHbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 02:31:44 -0500
Received: from mail-px0-f182.google.com ([209.85.216.182]:52175 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673Ab0AWHbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 02:31:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=F0qtGPUCfpfGmEGabh38JkTOagABMDmLXZ8Fk484BgMQ3XcZv2ZZZCcu+wJcZGtc4W
         UuaiO9qdR7PKR/V+yvgswHjUe6rmRqaNgQUpMpWFvuaSSX0X1pW8XzDoT6FeOQvStZKc
         MERJn2HL9lBbRjiZytKN2X90emHqV2RIw+nDE=
MIME-Version: 1.0
Date: Fri, 22 Jan 2010 23:31:43 -0800
Message-ID: <cf70f0211001222331y17af1f56oe7d4e61c1d38d7d3@mail.gmail.com>
Subject: measureing kernel & application boottime's
From: Shivdas Gujare <shivdas.tech@gmail.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       tim.bird@am.sony.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tim/all,

I am trying to measure kernel boottime along with measuring
application process start time on ARM V6 platform.
Because of few reasons, I have to stick to kernel 2.6.25(can't upgrade
it to latest).

While measuring application process times, I use "cat /proc/uptime"
when I start a process (I am not sure, if this is the best way to
measure time , please suggest if any).
For kernel, I use CONFIG_PRINTK_TIME macro. my application loads a
kernel module.
So, my question is how "/proc/uptime" relates to PRINTK_TIME timestamps?

I see, "uptime" uses
        do_posix_clock_monotonic_gettime(&uptime);
        monotonic_to_bootbased(&uptime);

while PRINTK_TIME does only, "cpu_clock(printk_cpu); "
but I am not able to understand practical difference between above two logics.

So, how do I correlate the time information from kernel dmesg , when
kernel module is loaded by my application(i.e. uptime measures just
before starting an application which loads kernel module).

Also, Is there any best method to measure application start time
(except bootchart, can't use it)?
Thanks for all your help.


Thanks and Regards,
Shivdas Gujare
