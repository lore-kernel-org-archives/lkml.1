Return-Path: <linux-kernel-owner+w=401wt.eu-S932539AbXFEOzB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932539AbXFEOzB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 10:55:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932457AbXFEOyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 10:54:46 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:49466 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932295AbXFEOyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 10:54:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:content-type:content-transfer-encoding:from;
        b=TJsIAvXvCOedQDY1WkVxRmBpzwTwrDDSKiDYhJmFYvSYM3D8+vyI533p9la8FOKoc4N7N6B1jedzlYSyXLAdvKQeKgxIqQg02ZrZsZTp03RUbgPe6VKr2mN5TtIf47OkGQ90Rd63sW9XH9SwShMyJ52usNhDQLQkVCKVHEm60Fw=
Message-ID: <46657924.4010505@googlemail.com>
Date: Tue, 05 Jun 2007 16:54:28 +0200
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, viro@zeniv.linux.org.uk,
       Uwe Bugla <uwe.bugla@gmx.de>, Ken Chen <kenchen@google.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Christoph Lameter <clameter@sgi.com>, Dave Airlie <airlied@linux.ie>,
       Andrea Righi <righiandr@users.sourceforge.net>,
       Netdev <netdev@vger.kernel.org>, Strobl Anton <a.strobl@aws-it.at>,
       Patrick McHardy <kaber@trash.net>
Subject: [1/2] 2.6.22-rc4: known regressions with patches
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.22-rc4
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

Subject    : JFFS2 issues
References : http://lists.infradead.org/pipermail/linux-mtd/2007-May/018426.html
Submitter  : Haavard Skinnemoen <hskinnemoen@atmel.com>
Caused-By  : commit 10731f83009e2556f98ffa5c7c2cbffe66dacfb3
             Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Handled-By : Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Patch      : http://lists.infradead.org/pipermail/linux-mtd/2007-May/018453.html
Status     : patch available



Memory management

Subject    : bug in i386 MTRR initialization
References : http://lkml.org/lkml/2007/5/19/93
Submitter  : Andrea Righi <righiandr@users.sourceforge.net>
Status     : patch available



Networking

Subject    : OOPS iproute2/tc/u32_destroy in 2.6.22-rc3-git6
References : http://lkml.org/lkml/2007/6/3/66
Submitter  : Strobl Anton <a.strobl@aws-it.at>
Handled-By : Patrick McHardy <kaber@trash.net>
Patch      : http://lkml.org/lkml/2007/6/3/137
Status     : patch available



Regards,
Michal

--
"Najbardziej brakowa³o mi twojego milczenia."
-- Andrzej Sapkowski "Co¶ wiêcej"
