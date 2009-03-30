Return-Path: <linux-kernel-owner+w=401wt.eu-S1756055AbZC3APj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055AbZC3APj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 20:15:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755023AbZC3APa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 20:15:30 -0400
Received: from tassadar.physics.auth.gr ([155.207.123.25]:52696 "EHLO
	tassadar.physics.auth.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754395AbZC3AP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 20:15:29 -0400
X-Greylist: delayed 808 seconds by postgrey-1.27 at vger.kernel.org; Sun, 29 Mar 2009 20:15:26 EDT
Date: Mon, 30 Mar 2009 03:01:50 +0300 (EEST)
From: Dimitris Zilaskos <dzila@tassadar.physics.auth.gr>
To: linux-kernel@vger.kernel.org
Subject: peak vnodes <number>
Message-ID: <Pine.LNX.4.64.0903300259500.27035@tassadar.physics.auth.gr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


After moving to 2.6.29 the following started showing up in kernel logs. 
What does it mean?


uname -an
Linux tassadar 2.6.29 #1 Sat Mar 28 22:52:51 EET 2009 i686 unknown unknown 
GNU/Linux


dmesg|grep peak|head
peak vnodes: 4164
peak vnodes: 4165
peak vnodes: 4166
peak vnodes: 4167
peak vnodes: 4168
peak vnodes: 4169
peak vnodes: 4170
peak vnodes: 4171
peak vnodes: 4172
peak vnodes: 4173

dmesg|grep peak|tail
peak vnodes: 10230
peak vnodes: 10231
peak vnodes: 10232
peak vnodes: 10233
peak vnodes: 10234
peak vnodes: 10235
peak vnodes: 10236
peak vnodes: 10237
peak vnodes: 10238
peak vnodes: 10239


dmesg|grep peak|wc -l
6076


Cheers,

-- 
=============================================================================
Dimitris Zilaskos
GridAUTH Operations Centre @ Aristotle University of Thessaloniki , Greece
Tel: +302310998988 Fax: +302310994309
http://www.grid.auth.gr
=============================================================================
