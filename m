Return-Path: <linux-kernel-owner+w=401wt.eu-S1755468AbZCEWPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468AbZCEWPt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 17:15:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753414AbZCEWPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 17:15:40 -0500
Received: from mx1.aecom.yu.edu ([129.98.1.51]:49288 "EHLO mx1.aecom.yu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753209AbZCEWPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 17:15:40 -0500
X-AuditID: 816201a0-a5e9dbb000001567-dd-49b04f0ab486
Mime-Version: 1.0
Message-Id: <a06240409c5d5e74a49d0@[129.98.90.227]>
Date: Thu, 5 Mar 2009 17:14:47 -0500
To: linux-kernel@vger.kernel.org
From: Maurice Volaski <mvolaski@aecom.yu.edu>
Subject: e1000 is subtly incompatible with jumbo frames
Cc: jesse.brandeburg@intel.com, jeffrey.t.kirsher@intel.com
Content-Type: text/plain; charset="us-ascii" ; format="flowed"
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a system using the e1000 driver with the MTU set to 9000. If I 
try FTP to get a file, the transfer does not start. Something about 
the 9000 MTU is preventing the NIC from receiving packets back from 
the FTP server. (The FTP server is on the same subnet and its NIC 
also has MTU 9000.) The 9000 MTU NIC works fine in every other 
respect, even allowing me to access the system via ssh. When I change 
the MTU to 1500, then FTP works fine. The problem is common to 
numerous kernel versions including 2.6.24 through 2.6.29-rc5.
-- 

Maurice Volaski, mvolaski@aecom.yu.edu
Computing Support, Rose F. Kennedy Center
Albert Einstein College of Medicine of Yeshiva University
