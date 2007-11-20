Return-Path: <linux-kernel-owner+w=401wt.eu-S1755262AbXKTAn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262AbXKTAn3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 19:43:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752270AbXKTAnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 19:43:21 -0500
Received: from smtpauth01.prod.mesa1.secureserver.net ([64.202.165.181]:38001
	"HELO smtpauth01.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752234AbXKTAnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 19:43:20 -0500
Message-ID: <47422D3B.8080704@seclark.us>
Date: Mon, 19 Nov 2007 19:41:31 -0500
From: Stephen Clark <Stephen.Clark@seclark.us>
Reply-To: Stephen.Clark@seclark.us
User-Agent: Mozilla/5.0 (X11; U; Linux 2.2.16-22smp i686; en-US; m18) Gecko/20010110 Netscape6/6.5
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Power Saving
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello List,

I am trying to get throttling to work on the following processor with 
linux 2.6.17-1.2142_FC4
with no luck.

AMD Athlon(tm) XP 1700+

cat /proc/acpi/processor/CPU0/info
processor id:            0
acpi id:                 0
bus mastering control:   no
power management:        yes
throttling control:      yes
limit interface:         yes

The /sys/devices/system/cpu/cpu0/cpufreq/* directory does not exist. I 
have modprobed
the following cpufreq* modules.

Module                  Size  Used by
cpufreq_stats           6101  0
cpufreq_powersave       2241  0
cpufreq_ondemand        7009  0
cpufreq_conservative     7265  0


What am I doing wrong?

Thanks Steve

-- 

"They that give up essential liberty to obtain temporary safety, 
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty 
decreases."  (Thomas Jefferson)



