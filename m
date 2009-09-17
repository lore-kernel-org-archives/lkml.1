Return-Path: <linux-kernel-owner+w=401wt.eu-S1753575AbZIQURd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575AbZIQURd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 16:17:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752922AbZIQUR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 16:17:29 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:62968 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904AbZIQUR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 16:17:28 -0400
Message-ID: <4AB29974.70602@vlnb.net>
Date: Fri, 18 Sep 2009 00:17:56 +0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       scst-devel <scst-devel@lists.sourceforge.net>
Subject: [ANNOUNCE]: Support of QLogic Fibre Channel 4/8Gb (24xx/25xx) HBA's
 added in target driver for SCST qla2x00t
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+vD7XNaSujx5zBtqLCCpywtP++neyJwXLj7M7
 nAOb2+27bBhLEOH9jpCTncjh0q0xQdySOx4EwtnFhMiZC5wDn1
 qhr8dSk05b1TzstLkDuVQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I'm glad to announce a merge of support of 4/8Gb (24xx/25xx) QLogic 
HBA's in SCST target driver qla2x00t v2.0.

Throughout the last three years ID7 and I have been working on an 
enterprise class Fibre Channel target based on the QLogic range of 4/8Gb 
HBA's. This has been solely funded by ID7 over the last years however 
given the positive contributions by many of the SCST community both 
personal and commercial, ID7 have chosen to merge with existing QLogic's 
open source driver qla2x00t and introduce the driver under GPL license 
for community use.

This driver was designed from ground up to perform at the highest of 
levels and interoperate with leading infrastructures, accordingly the 
design and flow is much more focused and structured whilst the stability 
is as you would expect at the Enterprise level.

Although there is a current QLogic target driver qla_isp, this driver 
has the key advantage that it was designed to be as simple as possible. 
As the result, this driver is a lot smaller, cleaner and mainline Linux 
kernel ready. After some cosmetic cleanups it's going to be pushed for 
the in-kernel inclusion together other SCST patches.

Another advantage is that this driver fully supports FC tapes, including 
transport level retries on data delivery problems.

At the moment qla2x00t v2.0 is available only from the SCST SVN trunk. 
You can download it by command:

$ svn co https://scst.svn.sourceforge.net/svnroot/scst/trunk

You can always find the latest info about qla2x00t driver from its page 
http://scst.sourceforge.net/target_qla2x0t.html.

Once again we are grateful for all the positive work and contributions 
and hopeful that this target helps drive SCST further forward as an 
Enterprise class target. We encourage people to introduce and evaluate 
this target driver.

Vladislav Bolkhovitin,
Mark Klarzynski, ID7 Ltd. (http://www.id-7.com)
