Return-Path: <linux-kernel-owner+w=401wt.eu-S1752245AbYGXDNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245AbYGXDNR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 23:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751155AbYGXDNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 23:13:00 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:15667 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbYGXDM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 23:12:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=Df6o1ASmp/TEAS1wl6t8R6139fN9ge/NXjcqFXH7zHwm7r69dpG65MVrEXvESg+drh
         IuO3UlWCxrva4VilnSMAfQ+A4FllQtx3cbL56edkidGPzbv5Ur+bbihvVpCfXhSxO7Fh
         JGeGSg2L1y5cvn/GDYH1TrYmOL5GN6byFUldo=
Message-ID: <4104961b0807232012r712bd456n26db52bc946efa9a@mail.gmail.com>
Date: Thu, 24 Jul 2008 11:12:57 +0800
From: "jidong xiao" <jidong.xiao@gmail.com>
To: "Bernhard Walle" <bwalle@suse.de>, "Vivek Goyal" <vgoyal@in.ibm.com>
Subject: Crashkernel memory reservation fails with 2.6.26
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,Bernhard/Vivek,
	I was facing the same issue as raised by Sachin sometime back, see below link:

http://lkml.org/lkml/2008/2/4/193

The difference is I am using kernel 2.6.26 while Sachin was using
2.6.24-rc8-mm1.

I saw you were discussing this issue but is there any result?Any
workaround for me?

Thanks
Jason

I was working on x86_64 box, and the message showed during the failure.

No NUMA configuration found
Faking a node at 0000000000000000-0000000230000000
Bootmem setup node 0 0000000000000000-0000000230000000
  NODE_DATA [0000000000012000 - 0000000000016fff]
  bootmap [0000000000017000 -  000000000005cfff] pages 46
  early res: 0 [0-fff] BIOS data page
  early res: 1 [6000-7fff] TRAMPOLINE
  early res: 2 [200000-921947] TEXT DATA BSS
  early res: 3 [37eb4000-37fef31d] RAMDISK
  early res: 4 [9f000-fffff] BIOS reserved
  early res: 5 [8000-11fff] PGTABLE
crashkernel reservation failed - memory is in use
