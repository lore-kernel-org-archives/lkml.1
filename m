Return-Path: <linux-kernel-owner+w=401wt.eu-S933561AbXHVRId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933561AbXHVRId (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 13:08:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760391AbXHVRI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 13:08:26 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:59242 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756506AbXHVRIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 13:08:25 -0400
Message-ID: <46CC6D84.7090504@linux.vnet.ibm.com>
Date: Wed, 22 Aug 2007 22:38:20 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: compile error: soundbus 2.6.23-rc3-mm1
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Andrew,

I see the following error while compiling on a ppc64 machine.


  CC [M]  sound/aoa/soundbus/core.o
sound/aoa/soundbus/core.c: In function ‘soundbus_uevent’:
sound/aoa/soundbus/core.c:91: error: ‘length’ undeclared (first use in this function)
sound/aoa/soundbus/core.c:91: error: (Each undeclared identifier is reported only once
sound/aoa/soundbus/core.c:91: error: for each function it appears in.)
make[3]: *** [sound/aoa/soundbus/core.o] Error 1
make[2]: *** [sound/aoa/soundbus] Error 2

The error seems to be related to recent changes to soundbus_uevent(), the length
parameter which was being filled by add_uevent_var() is now gone.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
