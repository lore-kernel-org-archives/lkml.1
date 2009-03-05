Return-Path: <linux-kernel-owner+w=401wt.eu-S1756482AbZCEXAJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482AbZCEXAJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 18:00:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755418AbZCEW7x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 17:59:53 -0500
Received: from mx1.aecom.yu.edu ([129.98.1.51]:52715 "EHLO mx1.aecom.yu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755265AbZCEW7w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 17:59:52 -0500
X-AuditID: 816201a0-a8de3bb000001567-0c-49b05966f8fa
Mime-Version: 1.0
Message-Id: <a0624040bc5d607eaef36@[129.98.90.227]>
In-Reply-To: <F169D4F5E1F1974DBFAFABF47F60C10A1E6EABF2@orsmsx507.amr.corp.intel.com>
References: <a06240409c5d5e74a49d0@[129.98.90.227]>
 <F169D4F5E1F1974DBFAFABF47F60C10A1E6EABF2@orsmsx507.amr.corp.intel.com>
Date: Thu, 5 Mar 2009 17:58:59 -0500
To: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From: Maurice Volaski <mvolaski@aecom.yu.edu>
Subject: RE: e1000 is subtly incompatible with jumbo frames
Cc: "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
Content-Type: text/plain; charset="us-ascii" ; format="flowed"
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 2:38 PM -0800 3/5/09, Brandeburg, Jesse wrote:
>Maurice Volaski wrote:
>>  I have a system using the e1000 driver with the MTU set to 9000. If I
>>  try FTP to get a file, the transfer does not start. Something about
>>  the 9000 MTU is preventing the NIC from receiving packets back from
>>  the FTP server. (The FTP server is on the same subnet and its NIC
>>  also has MTU 9000.) The 9000 MTU NIC works fine in every other
>>  respect, even allowing me to access the system via ssh. When I change
>>  the MTU to 1500, then FTP works fine. The problem is common to
>>  numerous kernel versions including 2.6.24 through 2.6.29-rc5.
>
>This sounds like you have not configured the MTU the same on both ends
>or some station in between is having issues with the large packets
>
>please double check your configuration.
>

Oh, sorry to trouble you, but I got tricked. I've been testing 
systems under VMWare Fusion on my Mac and it doesn't support jumbo 
frames. I got tricked because the identical OS running on real 
hardware was behaving identically, but the new switch it's connecting 
to had jumbo frames turned off, so naturally it shows the same 
problem. With jumbo frames turned on, it's now transferring fine.

At least anyone now if anyone else has an odd problem with FTP, 
they'll know to what to check.
-- 

Maurice Volaski, mvolaski@aecom.yu.edu
Computing Support, Rose F. Kennedy Center
Albert Einstein College of Medicine of Yeshiva University
