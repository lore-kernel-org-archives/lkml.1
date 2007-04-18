Return-Path: <linux-kernel-owner+w=401wt.eu-S2992948AbXDRXOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992948AbXDRXOP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 19:14:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992952AbXDRXOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 19:14:15 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:31881 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992948AbXDRXON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 19:14:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=bSfCjDL1UlR543C3LdOxt45rNPqg1OlmbU4RiufWNo/mgpU/kzhaehJMp5x2prhBXLTQxDXLcV1OyI2VTlmHrriURZUChswM9qrYCtSPbKczJC4iYHwpvt86wuCCILiwCYXSixv+1/OMNOJRJT0PIB9Caq6Ai3phRQwvi4y4R2A=
From: Denis Vlasenko <vda.linux@googlemail.com>
To: linux-kernel@vger.kernel.org
Subject: Upgraded to 2.6.20.7 - positives
Date: Thu, 19 Apr 2007 01:14:05 +0200
User-Agent: KMail/1.8.2
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704190114.05885.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi kernel people,

Just upgraded by home box to 2.6.20.7. Wow.

* Reiser3 mount times are drastically reduced,
  even when journal replay is needed
  (I have few 100Gb+ reiser3 partitions mounted at boot)
* sit pseudo-interface is gone. In previous kernel, I tried
  to disable it in kernel config to no avial. Now it was easy
  to simply compile it as a module.
* From make menuconfig questions it looks like SATA/PATA
  rewrite (in the form of libata) is almost finished. Hehe,
  untangling IDE mess was quite a feat, and Jeff did it. Kudos.

Need to check now whether losetup oopses are gone too,
or hunt them down if they are still with us :)

Thanks everybody for your amazing work.
--
vda
