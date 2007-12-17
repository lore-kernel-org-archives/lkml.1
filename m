Return-Path: <linux-kernel-owner+w=401wt.eu-S1759288AbXLQRvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759288AbXLQRvm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 12:51:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754314AbXLQRvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 12:51:35 -0500
Received: from smtpauth11.prod.mesa1.secureserver.net ([64.202.165.33]:54003
	"HELO smtpauth11.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753980AbXLQRve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 12:51:34 -0500
Message-ID: <4766B724.7090106@seclark.us>
Date: Mon, 17 Dec 2007 12:51:32 -0500
From: Stephen Clark <Stephen.Clark@seclark.us>
Reply-To: Stephen.Clark@seclark.us
User-Agent: Mozilla Thunderbird 1.0.8-1.1.fc4 (X11/20060501)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: cpuinfo_cur_freq always max
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Running linux 2.6.23.1-21.fc7 
/sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_cur_freq
correctly reflects the cpu speed, when idle it is 996000 and when 
compiling it is 1826000.
Its also the same as what is in /proc/cpuinfo.

But with 2.6.23.8-34.fc7 
/sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_cur_freq
is always the max cpu speed of 1826000.

While cpuinfo_cur_freq is the max 1826000 /proc/cpuinfo relflects the 
correct speed when idle of
996000

This is on an asus laptop with an intel core 2 duo T5600 processor.

Anyone else see this problem.

Regards,
Steve

-- 

"They that give up essential liberty to obtain temporary safety, 
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty 
decreases."  (Thomas Jefferson)



