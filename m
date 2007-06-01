Return-Path: <linux-kernel-owner+w=401wt.eu-S1761562AbXFAMWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761562AbXFAMWW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 08:22:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759881AbXFAMWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 08:22:00 -0400
Received: from wr-out-0506.google.com ([64.233.184.233]:54199 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759568AbXFAMV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 08:21:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=E1wbyhZkrZHBfii4hXL+W7djYiI/Og3Q/yNsetDgXxy26JStlRTKGFqFon0kUn3XRQkiyAUI1uU+Ln34ImycVUdDzYnjCpZnGvwvzx9bWMFkRJQtGA/POWjBH2o0G5YMdHyrOXrYzKuYkyHfGybRKKJ6XKw5yVvTJQkcDDg6Hvg=
Message-ID: <46600F44.3030109@googlemail.com>
Date: Fri, 01 Jun 2007 14:21:24 +0200
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
       xfs-masters@oss.sgi.com, Jeremy Fitzhardinge <jeremy@goop.org>,
       David Chinner <dgc@sgi.com>, jffs-dev@axis.com,
       David Woodhouse <dwmw2@infradead.org>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Uwe Bugla <uwe.bugla@gmx.de>, viro@zeniv.linux.org.uk,
       Ken Chen <kenchen@google.com>, linux-arm-kernel@lists.arm.linux.org.uk,
       Qi Yong <qiyong@fc-cn.com>, Russell King <rmk+lkml@arm.linux.org.uk>
Subject: [1/3] 2.6.22-rc3: known regressions with patches v2
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.22-rc3
with patches available.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions



ARM

Subject    : arch/arm/plat-s3c24xx/devs.c build errors
References : http://lkml.org/lkml/2007/5/28/18
Submitter  : Qi Yong <qiyong@fc-cn.com>
Status     : patch available in -arm tree



Block devices

Subject    : loop devices limited to one single device
References : http://lkml.org/lkml/2007/5/16/229
Submitter  : Uwe Bugla <uwe.bugla@gmx.de>
Handled-By : 
Patch      : http://lkml.org/lkml/2007/5/21/483
Status     : patch available



File systems

Subject    : JFFS2 issues
References : http://lists.infradead.org/pipermail/linux-mtd/2007-May/018426.html
Submitter  : Haavard Skinnemoen <hskinnemoen@atmel.com>
Caused-By  : commit 10731f83009e2556f98ffa5c7c2cbffe66dacfb3
             Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Handled-By : Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Patch      : http://lists.infradead.org/pipermail/linux-mtd/2007-May/018453.html
Status     : patch available

Subject    : 2.6.21-git10/11: files getting truncated on xfs
References : http://lkml.org/lkml/2007/5/9/410
Submitter  : Jeremy Fitzhardinge <jeremy@goop.org>
Handled-By : David Chinner <dgc@sgi.com>
Patch      : http://lkml.org/lkml/2007/5/12/93
Status     : patch available



Regards,
Michal

--
"Najbardziej brakowa³o mi twojego milczenia."
-- Andrzej Sapkowski "Co¶ wiêcej"

