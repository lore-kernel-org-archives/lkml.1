Return-Path: <linux-kernel-owner+w=401wt.eu-S1756374AbZCaAGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756374AbZCaAGU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 20:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760416AbZCaAF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 20:05:59 -0400
Received: from n76.bullet.mail.sp1.yahoo.com ([98.136.44.48]:35015 "HELO
	n76.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1761890AbZCaAF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 20:05:56 -0400
X-Greylist: delayed 315 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Mar 2009 20:05:56 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 517801.5485.bm@omp114.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type;
  b=cYzuSL5i/XS1Kqeze104My2ocJR0iJiRRD2ICZql2uZ12nR3ttkXleFvfrIJSnzmQI+E7AsN0lBug05uWdpIEj6OOezkT3MdOdDF8EHfKcvyhuuA0app4ELZBDJvxcqHAH+ijY5OxKdkutT1k4KarPD7qx5SrjmV7dnVCSdr7SQ=;
Message-ID: <109659.83689.qm@web111311.mail.gq1.yahoo.com>
X-YMail-OSG: 1.pYxwQVM1kN1D6vsxlVNpzjd4bEe4ea_gwPX0V.T218iUxsDBfIH9oFnccKuvrpE8IMY__FntEjXjL_iWmBmNmscZk7Vd6o_QR0cxgNqJ8dEbCWu.fNmpYa24exqGFMTRP3t4JsHCVJk48kggHHzjIshj5yUitrGvimgvgnreMxE1vrubrdzweXUE13sR0U_L0gVh88IqmlMs.vOzdupr02i999cfKNqBRuiW.W45iUclOwsNT1eGoSlcuitSz.PwajE5hOlxpmC8JHr2f4AcjN9DNi4C5C.wYwwsSK_HSK7KraWr_PTQaMeIv1RRa7DEJ5RUDcMwTHiWCqUaJwt62M9Zg6s2Q9.mo-
X-Mailer: YahooMailRC/1277.35 YahooMailWebService/0.7.289.1
Date: Mon, 30 Mar 2009 17:00:37 -0700 (PDT)
From: Calvin Arndt <calarndt@yahoo.com>
Reply-To: Calvin Arndt <calarndt@yahoo.com>
Subject: kernel soft lockup  ECS-P6VEM3 VIA C3 GIGAPRO CPU motherboard
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi, we have an issue with 2.6 and the CentaurHauls CPU on the ECS-P6VEM3 VIA C3 GIGAPRO CPU motherboard.
The kernel stops responding to pings, loses ssh connections on all network interfaces.
This occurs after 10 hours and 37 minutes of uptime. It repeats without fail.
The interesting issue is that it is recoverable! Walk up to the system and hit any key and all comes back to life!
Actually any input (via hardware) will make it start responding again. IE. input via the serial console.

I'm guessing something has disabled soft interrupts until a hardware interrupt is received. But I don't have a
clue as to how to troubleshoot this any further. This has been tested with 2.6.25.20 and up to current.
This kernel works flawlessly on our other hardware (wrap 2c, AMD 2600+ and several others)

Any thoughts?
TIA

Calvin....


root@tester:~# cat /proc/cpuinfo
processor       : 0
vendor_id       : CentaurHauls
cpu family      : 6
model           : 7
model name      : VIA Ezra
stepping        : 8
cpu MHz         : 734.957
cache size      : 64 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu de tsc msr cx8 mtrr pge mmx 3dnow
bogomips        : 1469.91
clflush size    : 32
power management:


ssh root@192.168.200.1 'while true;do uptime;sleep 10;done' 
 01:17:05 up 10:34, load average: 0.00, 0.00, 0.00
 01:17:15 up 10:35, load average: 0.00, 0.00, 0.00
 01:17:25 up 10:35, load average: 0.00, 0.00, 0.00
 01:17:35 up 10:35, load average: 0.00, 0.00, 0.00
 01:17:45 up 10:35, load average: 0.00, 0.00, 0.00
 01:17:55 up 10:35, load average: 0.00, 0.00, 0.00
 01:18:05 up 10:35, load average: 0.00, 0.00, 0.00
 01:18:15 up 10:36, load average: 0.00, 0.00, 0.00
 01:18:25 up 10:36, load average: 0.00, 0.00, 0.00
 01:18:35 up 10:36, load average: 0.00, 0.00, 0.00
 01:18:45 up 10:36, load average: 0.00, 0.00, 0.00
 01:18:55 up 10:36, load average: 0.00, 0.00, 0.00
 01:19:05 up 10:36, load average: 0.00, 0.00, 0.00
 01:19:15 up 10:37, load average: 0.00, 0.00, 0.00
 01:19:25 up 10:37, load average: 0.00, 0.00, 0.00
 01:19:35 up 10:37, load average: 0.00, 0.00, 0.00
Read from remote host 192.168.200.1: Connection timed out


      

