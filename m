Return-Path: <linux-kernel-owner+w=401wt.eu-S1753702Ab0AEEv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702Ab0AEEv6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 23:51:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752923Ab0AEEv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 23:51:57 -0500
Received: from mail192.messagelabs.com ([216.82.241.243]:12915 "EHLO
	mail192.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612Ab0AEEv4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 23:51:56 -0500
X-VirusChecked: Checked
X-Env-Sender: Venkappa.Mala@lntinfotech.com
X-Msg-Ref: server-9.tower-192.messagelabs.com!1262667111!24435156!1
X-StarScan-Version: 6.2.4; banners=lntinfotech.com,-,-
X-Originating-IP: [203.101.96.8]
From: Venkappa Mala <Venkappa.Mala@lntinfotech.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 5 Jan 2010 10:21:11 +0530
Subject: Linux kernel crash dumps for ARM
Thread-Topic: Linux kernel crash dumps for ARM
Thread-Index: AQHKjcJ4PAPamaQdJEySpaX6qzPElZGGaeIN
Message-ID: <EB1A7C66AD0C92419BFFC785A947865A09EA8C912A@BLRINMSMBX01.bglrodc.lntinfotech.com>
References: <EB1A7C66AD0C92419BFFC785A947865A09EA8C9129@BLRINMSMBX01.bglrodc.lntinfotech.com>
In-Reply-To: <EB1A7C66AD0C92419BFFC785A947865A09EA8C9129@BLRINMSMBX01.bglrodc.lntinfotech.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

With respect to "Linux kernel crash dumps for ARM", i have some doubts which are described as below.

If the machine has crashed so badly that you cannot enter commands or
the disk is not available then you have three options :-

(1) Hand copy the text from the screen

(2) capture crash logs using Minicom.

(3) save the crash data to a floppy disk or video rom or a swap partition or reserved memory.

In the above three options, 1 & 2 are known and works as well.

Regarding 3 option,
----------------------------
i would like to support for ARM11.

As far as i know, the supported linux kernel crash dumps are
"lkcd, netdump,diskdump, mini kernel dump and kdump/kexec".
These are supported for x86 and PowerPC architectures with some constrains.

i have some queries with respect to ARM supports, these are

1.) kexec is supported in latest kernels
        example: 2.6.29 kernel
        File: arch/arm/kernel/machine_kexec.c

    - is this working well or is there any constraints?

2) As per kexec supports, kexec-tool is required and this allows you to load directly
   to a new kernel from the currently running one

    As from my side, i am not able to find arm implementation support in kexec-tools/crash sources.

   - is kexce-tool supported for ARM or not?

3) In lkcd, netdump,diskdump, mini kernel dump and kdump/kexec tools,

   - which is the best choice for ARM or are there any best crash dump tool for ARM?

Please clarify my queries.

Best Regards,
Venkappa


This Email may contain confidential or privileged information for the intended recipient (s) If you are not the intended recipient, please do not use or disseminate the information, notify the sender and delete it from your system.

______________________________________________________________________
