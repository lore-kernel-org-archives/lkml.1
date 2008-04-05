Return-Path: <linux-kernel-owner+w=401wt.eu-S1754707AbYDESQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707AbYDESQQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 14:16:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752880AbYDESP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 14:15:59 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:50899 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756AbYDESP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 14:15:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=Zq1ARwJor97HoSEZGG5+4Wa2aoL9tlc0oFD309hEW0RzozS9d7FC4iY4INgbRn+cmir93JBdzP1kRk9ECphk80vQVhHfhTKeN4/QC4atPnXvPZesxWj5W83oD94OdfawJ6/mcELBkFLYVUDYQDKd3WAacE8gPZks2Q49+yaafvA=
From: Balaji Rao <balajirrao@gmail.com>
Organization: National Institute of Technology Karnataka
To: linux-kernel@vger.kernel.org
Subject: [RFC][-mm] [0/2] Basic stats for cgroups V2
Date: Sat, 5 Apr 2008 23:39:42 +0530
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: containers@lists.osdl.org, dhaval@linux.vnet.ibm.com, balbir@in.ibm.com,
       containers@lists.osdl.org, menage@google.com, a.p.zijlstra@chello.nl,
       Ingo Molnar <mingo@elte.hu>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200804052339.42474.balajirrao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

V1->V2
- Fixed a possible race in cpu_cgroup_read_stat. Thank you Paul for pointing this out.
- A few other naming changes.

This patchset is a first step towards implementing stats for cgroup 
subsystems. Only a few trivial stats for cpu and memory resource controller 
have been implemented for now. Please provide comments on the general 
direction and any suggestions on how you would like the cgroupstats framework 
to be implemented.

roadmap
--------
implement a generic statistics framework for cgroups,
unification with taskstats/netlink interface,
add more statistics

-- 
regards,
Balaji Rao
Dept. of Mechanical Engineering,
National Institute of Technology Karnataka, India
