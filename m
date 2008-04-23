Return-Path: <linux-kernel-owner+w=401wt.eu-S1757596AbYDWNoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596AbYDWNoy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 09:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753715AbYDWNoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 09:44:32 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:49575 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425AbYDWNob convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 09:44:31 -0400
Date: Wed, 23 Apr 2008 15:44:26 +0200 (CEST)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: evil@sheep.housecafe.de
To: LKML <linux-kernel@vger.kernel.org>
cc: linux-ide@vger.kernel.org
Subject: ide: failed opcode was: 0xea
Message-ID: <alpine.DEB.1.10.0804231533280.4028@sheep.housecafe.de>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V01U2FsdGVkX19yqhhbfK5T6ohCKH0cTYrur7SokkXLlVYLLXf
 6wsAqLOj9+aNVgFDgacadt3H/YNi3kgpkgJ3OfQO/3eTRKWQcX
 CUoAMpNtKcDYHsS/vMtqg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

during the last days the following messages showed up in my logs:

hdc: task_no_data_intr: status=0xd0 { Busy }
ide: failed opcode was: 0xea

It's often hdc, sometimes hdd and I have to admit that at least hdd
is pretty "warm":

/dev/hdc: SAMSUNG HD400LD: 40°C
/dev/hdd: ST3160023A: 48°C

That being said, the disks are working OK and have been on that 
temperature for some time now. The regular SMART checks report no errors 
either.

The errors showed up in the past a few times but now with 2.6.25 (and 
early -rc) they seem to appear more often. From /var/log/messages:

       5 Aug 19 failed opcode was: 0xea           (2007)
       4 Mar 10 failed opcode was: 0xea           (2008)
       2 Mar 11 failed opcode was: 0xea
       7 Mar 12 failed opcode was: 0xea
       3 Apr 17 ide: failed opcode was: 0xea
      11 Apr 21 ide: failed opcode was: 0xea
       1 Apr 23 ide: failed opcode was: 0xea

Q: What do these messages mean? Should I be worried?

Thanks,
Christian.
-- 
BOFH excuse #442:

Trojan horse ran out of hay
