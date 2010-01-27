Return-Path: <linux-kernel-owner+w=401wt.eu-S932234Ab0A0Xf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234Ab0A0Xf7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 18:35:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755431Ab0A0Xf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 18:35:58 -0500
Received: from mailhub2.otago.ac.nz ([139.80.64.247]:47039 "EHLO
	mailhub2.otago.ac.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754719Ab0A0Xf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 18:35:58 -0500
X-Greylist: delayed 1151 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Jan 2010 18:35:57 EST
Message-Id: <A1D71FDC-3176-4792-83ED-3ACAA3D61CFF@cs.otago.ac.nz>
From: zhiyi <zhuang@cs.otago.ac.nz>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v926)
Subject: nr_cpu_ids incorrect on AMD Quad-Core Opteron 8380
Date: Thu, 28 Jan 2010 12:16:44 +1300
Cc: Zhiyi Huang <hzy@cs.otago.ac.nz>
X-Mailer: Apple Mail (2.926)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I have just found the value of nr_cpu_ids is 32, instead of 16 on my  
new Dell PowerEdge R905 which has 16 cpus (4 quad-core Opteron 8380).  
However, /proc/cpuinfo displays the right number (16).
I have searched the archive but found no related subject.  Is there  
any patch already available to fix the problem?
I am using 2.6.31-4 and verified this incorrect value (32) using a  
module.
Please CC responses to my personal email.
Cheers,
Zhiyi
