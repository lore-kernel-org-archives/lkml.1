Return-Path: <linux-kernel-owner+w=401wt.eu-S1758938AbYFXRZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758938AbYFXRZV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 13:25:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751662AbYFXRZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 13:25:09 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:49758 "EHLO pardus.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751426AbYFXRZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 13:25:08 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: Dave Jones <davej@redhat.com>
Subject: Intel 8100 Error inserting acpi_cpufreq
Date: Tue, 24 Jun 2008 20:25:01 +0300
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200806242025.04252.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi;

We received a bug report from one of our users, reporter says "modprobe acpi-cpufreq" ends up with following

FATAL: Error inserting acpi_cpufreq (/lib/modules/2.6.25.5-97/kernel/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.ko):
No such device

and after that try dmesg [1] starts to show

[...]
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
padlock: VIA PadLock not detected.
wlan0: no IPv6 routers present
ACPI Error (psargs-0355): [\_PR_.CPU0._PSS] Namespace lookup failure, AE_NOT_FOUND
ACPI Error (psparse-0537): Method parse/execution failed [\_PR_.CPU1._PSS] (Node f74c7060), AE_NOT_FOUND
ACPI Exception (processor_perflib-0255): AE_NOT_FOUND, Evaluating _PSS  [20070126]
[...]

Although original report against 2.6.25.5 reporter also tried 2.6.25.8 without success.

Any tips really appreciated and if anything else is needed please just tell...

[1] http://bugs.pardus.org.tr/attachment.cgi?id=2801

Cheers
-- 
S.Çağlar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in house!
