Return-Path: <linux-kernel-owner+w=401wt.eu-S1753286AbXE2MyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286AbXE2MyS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 08:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753954AbXE2Mxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 08:53:41 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:37005 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753914AbXE2Mxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 08:53:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=tvgNN2ysXOF4QGyiq9hnz+utf4vlut7g4j9W0Ox5AnuwrOzD9jIwijjLrY4fTekX2kornVVnSppFixb590QX51UAf23I0y4wF5DeXr0ysnsQddDy1Ujlzp+xrlmMQumcYF0wztN1qreWePAbBSNZRaq0AxPw1g0stZK5R27AwiE=
Message-ID: <465C2249.40400@googlemail.com>
Date: Tue, 29 May 2007 14:53:29 +0200
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-arm-kernel@lists.arm.linux.org.uk, Qi Yong <qiyong@fc-cn.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>, viro@zeniv.linux.org.uk,
       Uwe Bugla <uwe.bugla@gmx.de>, Ken Chen <kenchen@google.com>,
       dri-devel@lists.sourceforge.net,
       "Cherwin R. Nooitmeer" <cherwin@gmail.com>,
       Dave Airlie <airlied@linux.ie>, xfs-masters@oss.sgi.com,
       Jeremy Fitzhardinge <jeremy@goop.org>, David Chinner <dgc@sgi.com>,
       Christoph Lameter <clameter@sgi.com>,
       Andrea Righi <righiandr@users.sourceforge.net>
Subject: [1/3] 2.6.22-rc3: known regressions with patches
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
Handled-By : Ken Chen <kenchen@google.com>
Patch      : http://lkml.org/lkml/2007/5/21/483
Status     : patch available


DRM

Subject    : kernel BUG at include/linux/slub_def.h:88 kmalloc_index()
References : http://bugzilla.kernel.org/show_bug.cgi?id=8476
Submitter  : Cherwin R. Nooitmeer <cherwin@gmail.com>
Status     : "Fix should be in my drm tree for the next mm.." Dave Airlie



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



Regards,
Michal

--
"Najbardziej brakowa³o mi twojego milczenia."
-- Andrzej Sapkowski "Co¶ wiêcej"


