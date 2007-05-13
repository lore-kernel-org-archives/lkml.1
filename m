Return-Path: <linux-kernel-owner+w=401wt.eu-S1759677AbXEMSPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759677AbXEMSPc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 14:15:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757510AbXEMSPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 14:15:20 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:62965 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756864AbXEMSPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 14:15:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=ZrWCGiiF6hmLDETJs9NYc0n433XZRbFJR8gp8RIDLLQSRFFoxa0mywe/SdgGarJ9YV4wvz4hkvJFIbikAf0P5I22H2O013nW+BN0mcDCsOghQPViq/liZsMxvupYGFtqsQCBbGXDZ4IG6cTSyQkc/Iso759Tp/fR7a00El2Yodw=
Message-ID: <46475595.4050105@googlemail.com>
Date: Sun, 13 May 2007 20:14:45 +0200
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, i2c@lm-sensors.org,
       Jean Delvare <khali@linux-fr.org>,
       Antonino Ingargiola <tritemio@gmail.com>, linux-ide@vger.kernel.org,
       Paul Mundt <lethal@linux-sh.org>, Tejun Heo <htejun@gmail.com>,
       Jeff Garzik <jeff@garzik.org>, linux-fsdevel@vger.kernel.org,
       xfs-masters@oss.sgi.com, Jeremy Fitzhardinge <jeremy@goop.org>,
       David Chinner <dgc@sgi.com>, Charles Gagalac <charle97@yahoo.com>,
       Davide Libenzi <davidel@xmailserver.org>
Subject: [1/2] 2.6.22-rc1: known regressions
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.22-rc.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions

(http://bugzilla.kernel.org/ is not available, information are not up-to-date)

I2C

Subject    : "Sensors Applet" give an error message "No chip detected"
References : http://lkml.org/lkml/2007/5/13/109
Submitter  : Antonino Ingargiola <tritemio@gmail.com>
Status     : Unknown



SATA/PATA

Subject    : libata crash on halt
References : http://marc.info/?l=linux-ide&m=117899827710565&w=2
Submitter  : Andrew Morton <akpm@linux-foundation.org>
Caused-By  : Tejun Heo <htejun@gmail.com>
             commit 920a4b1038e442700a1cfac77ea7e20bd615a2c3
Status     : problem is being debugged

Subject    : libata reset-seq merge broke sata_sil on sh
References : http://lkml.org/lkml/2007/5/10/63
Submitter  : Paul Mundt <lethal@linux-sh.org>
Handled-By : Tejun Heo <htejun@gmail.com>
Caused-By  : commit 4750def52cb2c21732dda9aa1d43a07db37b0186
Status     : problem is being debugged



File systems

Subject    : applications under wine freezes
References : http://bugzilla.kernel.org/show_bug.cgi?id=8462
Submitter  : Charles Gagalac <charle97@yahoo.com>
Caused-By  : Davide Libenzi <davidel@xmailserver.org>
             commit 6192bd536f96c6a0d969081bc71ae24f9319bfdc
Handled-By : Davide Libenzi <davidel@xmailserver.org>
Status     : problem is being debugged

Subject    : 2.6.21-git10/11: files getting truncated on xfs
References : http://lkml.org/lkml/2007/5/9/410
Submitter  : Jeremy Fitzhardinge <jeremy@goop.org>
Handled-By : David Chinner <dgc@sgi.com>
Patch      : http://lkml.org/lkml/2007/5/12/93
Status     : patch was suggested



Regards,
Michal

-- 
Michal K. K. Piotrowski
Kernel Monkeys
(http://kernel.wikidot.com/start)
