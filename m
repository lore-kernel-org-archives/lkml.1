Return-Path: <linux-kernel-owner+w=401wt.eu-S1751440AbXEXOFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751440AbXEXOFo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 10:05:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751266AbXEXOEk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 10:04:40 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:35582 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbXEXOEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 10:04:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=THoUoSODn9HHKBxDZxkyiZtjfSl/Q6ZI9VCgXTFp8aWa/uTJKYPvM8iYZVJUCJ15MrF5+Kv7pUzw8EISfma362Q6jpUwm1qwjVCDxZEPDQp+YvCPnumel8GlEvH5rzDb1iO24+gjfkn4jX8MAuNVFN+84kc61sl5B3Fhot6fcQA=
Message-ID: <46559B62.5040903@googlemail.com>
Date: Thu, 24 May 2007 16:04:18 +0200
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, viro@zeniv.linux.org.uk,
       Uwe Bugla <uwe.bugla@gmx.de>, Ken Chen <kenchen@google.com>,
       xfs-masters@oss.sgi.com, Jeremy Fitzhardinge <jeremy@goop.org>,
       David Chinner <dgc@sgi.com>,
       Andrea Righi <righiandr@users.sourceforge.net>,
       Christoph Lameter <clameter@sgi.com>, linux-ide@vger.kernel.org,
       Paul Mundt <lethal@linux-sh.org>, Tejun Heo <htejun@gmail.com>,
       Jeff Garzik <jeff@garzik.org>,
       Francis Russell <francisrussell@btopenworld.com>,
       Alan Cox <alan@redhat.com>, Andi Kleen <ak@suse.de>, discuss@x86-64.org,
       Ben Collins <ben.collins@ubuntu.com>
Subject: 2.6.22-rc2: known regressions with patches
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.22-rc2
with patches available.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions



Block devices

Subject    : loop devices limited to one single device
References : http://lkml.org/lkml/2007/5/16/229
Submitter  : Uwe Bugla <uwe.bugla@gmx.de>
Handled-By : Ken Chen <kenchen@google.com>
Patch      : http://lkml.org/lkml/2007/5/21/483
Status     : patch available



File systems

Subject    : 2.6.21-git10/11: files getting truncated on xfs
References : http://lkml.org/lkml/2007/5/9/410
Submitter  : Jeremy Fitzhardinge <jeremy@goop.org>
Handled-By : David Chinner <dgc@sgi.com>
Patch      : http://lkml.org/lkml/2007/5/12/93
Status     : patch available



Memory management

Subject    : bug in i386 MTRR initialization
References : http://lkml.org/lkml/2007/5/19/93
Submitter  : Andrea Righi <righiandr@users.sourceforge.net>
Status     : patch available



SATA/PATA

Subject    : pata_via appears to incorrectly detects 40-pin cable
References : http://lkml.org/lkml/2007/5/17/273
             http://bugzilla.kernel.org/show_bug.cgi?id=8142
Submitter  : Francis Russell <francisrussell@btopenworld.com>
Status     : Not really a regression. Alan seems to have a general fix.
             (Tejun Heo)

Subject    : libata reset-seq merge broke sata_sil on sh
References : http://lkml.org/lkml/2007/5/10/63
Submitter  : Paul Mundt <lethal@linux-sh.org>
Handled-By : Tejun Heo <htejun@gmail.com>
Caused-By  : commit 4750def52cb2c21732dda9aa1d43a07db37b0186
Patch      : http://lkml.org/lkml/2007/5/19/161
Status     : patch available



x86-64

Subject    : BUG: at mm/slab.c:777 __find_general_cachep()
References : http://lkml.org/lkml/2007/5/18/17
Submitter  : Jeff Garzik <jeff@garzik.org>
Handled-By : Ben Collins <ben.collins@ubuntu.com>
Patch      : http://lkml.org/lkml/2007/5/18/19
Status     : patch available



Regards,
Michal

--
"Najbardziej brakowa³o mi twojego milczenia."
-- Andrzej Sapkowski "Co¶ wiêcej"

