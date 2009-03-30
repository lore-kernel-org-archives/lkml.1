Return-Path: <linux-kernel-owner+w=401wt.eu-S1753081AbZC3QCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081AbZC3QCT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 12:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753318AbZC3QCE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 12:02:04 -0400
Received: from mail-gx0-f160.google.com ([209.85.217.160]:51292 "EHLO
	mail-gx0-f160.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbZC3QCD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 12:02:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=SJUsgUsGVN32s14GZBmJZ0pJcpcpRs7NUqBPnDOf3JUQ+tgAIZioL/0kbWHowj1zso
         4iEo5K0sQSecf+sb7ytG/rY19amoqRHf1f7xWMl1qRq35V7FpYVZyDIK9CbfITX0HdsB
         ZkW61riYbpxMSXnpH9w/cBAlI5ic7q3w+GAO0=
MIME-Version: 1.0
Date: Mon, 30 Mar 2009 12:01:59 -0400
Message-ID: <804dabb00903300901n37e54577ka3000c106a937950@mail.gmail.com>
Subject: compilation error in linus git tree
From: Peter Teoh <htmldeveloper@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

just git pulled and compiled with the following errors:

  CC [M]  arch/x86/kernel/cpu/cpufreq/speedstep-lib.o
  CC [M]  arch/x86/kernel/cpu/cpufreq/p4-clockmod.o
arch/x86/kernel/cpu/cpufreq/p4-clockmod.c: In function ‘cpufreq_p4_cpu_init’:
arch/x86/kernel/cpu/cpufreq/p4-clockmod.c:232: error: implicit
declaration of function ‘recalibrate_cpu_khz’
make[3]: *** [arch/x86/kernel/cpu/cpufreq/p4-clockmod.o] Error 1
make[2]: *** [arch/x86/kernel/cpu/cpufreq] Error 2
make[1]: *** [arch/x86/kernel/cpu] Error 2
make: *** [arch/x86/kernel] Error 2

not sure where is the best place to put this, but the error is resolved via

extern int recalibrate_cpu_khz(void);

inside the file:

arch/x86/kernel/cpu/cpufreq/p4-clockmod.c

thanks.

-- 
Regards,
Peter Teoh
