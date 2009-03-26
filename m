Return-Path: <linux-kernel-owner+w=401wt.eu-S1761266AbZCZTRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761266AbZCZTRi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 15:17:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760020AbZCZTRU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 15:17:20 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:57198 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759844AbZCZTRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 15:17:18 -0400
Message-ID: <49CBD4F8.5080605@vlnb.net>
Date: Thu, 26 Mar 2009 22:18:16 +0300
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: scst-devel <scst-devel@lists.sourceforge.net>
CC: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [ANNOUNCE]: Auto notification of initiators by SCST targets about
 devices additional/removal or their size changed implemented
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18ifPJjhddbz0WQTk3JZ+39buArb5bL4+6IPGg
 emG++8xRDmtQwmvqUTSRXi/0QlbsKGjt6u7rntxfPc9Wzo0wEc
 ZnioWLnt1Qmrgm7U/U95A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All

In the recent commits in SCST SVN repository I added to SCST ability to 
automatically notify initiators about the following two types of events:

1. Devices addition or removal (REPORTED LUNS DATA CHANGED)

2. If any device changed its size (CAPACITY DATA CHANGED)

Both types of notifications are supported: Asynchronous Events 
Notifications (AEN) and Unit Attentions. If a target driver supports 
AENs, they will be used, otherwise, Unit Attentions will be used.

At the moment in Linux only open-iscsi partially understands those 
events. It can see added devices. But it doesn't process devices removal 
or size changed events.

I'm going to make development freeze of SCST 1.0.1 tomorrow. Then after 
few weeks of testing 1.0.1 is going to be released.

SCST is an alternative implementation of SCSI target subsystem for 
Linux. You can find more information about it on its home page 
http://scst.sourceforge.net

Vlad
