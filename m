Return-Path: <linux-kernel-owner+w=401wt.eu-S1755625AbYFYWnF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625AbYFYWnF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 18:43:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752736AbYFYWmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 18:42:55 -0400
Received: from mga14.intel.com ([143.182.124.37]:61376 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344AbYFYWmy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 18:42:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,704,1204531200"; 
   d="scan'208";a="2697932"
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "caglar@pardus.org.tr" <caglar@pardus.org.tr>,
       Dave Jones <davej@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Date: Wed, 25 Jun 2008 15:46:21 -0700
Subject: RE: Intel 8100 Error inserting acpi_cpufreq
Thread-Topic: Intel 8100 Error inserting acpi_cpufreq
Thread-Index: AcjWH3dnhH7FS9VtTwqrkxj2w8I3RAA9Wsbg
Message-ID: <7E82351C108FA840AB1866AC776AEC4606577D9A@orsmsx505.amr.corp.intel.com>
References: <200806242025.04252.caglar@pardus.org.tr>
In-Reply-To: <200806242025.04252.caglar@pardus.org.tr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-9"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Most likely BIOS is not exporting relevant ACPI tables for the driver to detect the frequencies and such.
Latest BIOS and enabling Speedstep in BIOS options will be the things to check.

Thanks,
Venki

>-----Original Message-----
>From: linux-kernel-owner@vger.kernel.org
>[mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of S.Çaglar Onur
>Sent: Tuesday, June 24, 2008 10:25 AM
>To: Dave Jones
>Cc: linux-kernel@vger.kernel.org; Len Brown
>Subject: Intel 8100 Error inserting acpi_cpufreq
>
>Hi;
>
>We received a bug report from one of our users, reporter says
>"modprobe acpi-cpufreq" ends up with following
>
>FATAL: Error inserting acpi_cpufreq
>(/lib/modules/2.6.25.5-97/kernel/arch/x86/kernel/cpu/cpufreq/ac
>pi-cpufreq.ko):
>No such device
>
>and after that try dmesg [1] starts to show
>
>[...]
>ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
>padlock: VIA PadLock not detected.
>wlan0: no IPv6 routers present
>ACPI Error (psargs-0355): [\_PR_.CPU0._PSS] Namespace lookup
>failure, AE_NOT_FOUND
>ACPI Error (psparse-0537): Method parse/execution failed
>[\_PR_.CPU1._PSS] (Node f74c7060), AE_NOT_FOUND
>ACPI Exception (processor_perflib-0255): AE_NOT_FOUND,
>Evaluating _PSS  [20070126]
>[...]
>
>Although original report against 2.6.25.5 reporter also tried
>2.6.25.8 without success.
>
>Any tips really appreciated and if anything else is needed
>please just tell...
>
>[1] http://bugs.pardus.org.tr/attachment.cgi?id=2801
>
>Cheers
>--
>S.Çaðlar Onur <caglar@pardus.org.tr>
>http://cekirdek.pardus.org.tr/~caglar/
>
>Linux is like living in a teepee. No Windows, no Gates and an
>Apache in house!
>--
>To unsubscribe from this list: send the line "unsubscribe
>linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
>
