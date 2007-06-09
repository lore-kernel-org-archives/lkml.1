Return-Path: <linux-kernel-owner+w=401wt.eu-S1757041AbXFIRlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757041AbXFIRlu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 13:41:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756732AbXFIRk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 13:40:59 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:62227 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757935AbXFIRkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 13:40:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:content-type:content-transfer-encoding:from;
        b=rBX20PMe28rLneUvkDIww/dJdlbNDKYsTEoRwh6DwJ1Lr0p2TRSKJdFE4/XuC0wVbgatmTPHAPNIJKaQSTU1vr6drz+w/ik7LRRqHajNxyEyGbc1by6+jvyeA6YF+mln5Q3QStKFOZBY6uu4+fjf76JcRPiO4F4by9dqW0tAWwI=
Message-ID: <466AE614.3080706@googlemail.com>
Date: Sat, 09 Jun 2007 19:40:36 +0200
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Udo A. Steinberg" <us15@os.inf.tu-dresden.de>,
       =?ISO-8859-2?Q?Bj=F6rn_Steinbrink?= <B.Steinbrink@gmx.de>,
       Dave Airlie <airlied@linux.ie>, Christoph Lameter <clameter@sgi.com>,
       Andrea Righi <righiandr@users.sourceforge.net>,
       Netdev <netdev@vger.kernel.org>, Samuel Ortiz <samuel@sortiz.org>,
       Andrey Borzenkov <arvidjaar@mail.ru>, Strobl Anton <a.strobl@aws-it.at>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Patrick McHardy <kaber@trash.net>
Subject: [1/2] 2.6.22-rc4: known regressions with patches v2
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



Unclassified

Subject    : kernel BUG at arch/i386/kernel/cpu/perfctr-watchdog.c:126!
References : http://lkml.org/lkml/2007/6/3/60
Submitter  : Udo A. Steinberg <us15@os.inf.tu-dresden.de>
Handled-By : Björn Steinbrink <B.Steinbrink@gmx.de>
Patch      : http://lkml.org/lkml/2007/6/8/23
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

Subject    : no irda0 interface (2.6.21 was OK), smsc does not find chip
References : http://lkml.org/lkml/2007/6/3/16
Submitter  : Andrey Borzenkov <arvidjaar@mail.ru>
Handled-By : Samuel Ortiz <samuel@sortiz.org>
             Bjorn Helgaas <bjorn.helgaas@hp.com>
Patch      : http://lkml.org/lkml/2007/6/7/237
Status     : patch was suggested



Regards,
Michal

--
"Najbardziej brakowa³o mi twojego milczenia."
-- Andrzej Sapkowski "Co¶ wiêcej"
