Return-Path: <linux-kernel-owner+w=401wt.eu-S1759220AbXI1Pcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759220AbXI1Pcn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 11:32:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753872AbXI1Pcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 11:32:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44993 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753772AbXI1Pce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 11:32:34 -0400
Date: Fri, 28 Sep 2007 11:32:20 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Avi Kivity <avi@qumranet.com>, Ingo Molnar <mingo@elte.hu>
Subject: Add missing profile=kvm option to
	Documentation/kernel-parameters.txt
Message-ID: <20070928153220.GA26969@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Avi Kivity <avi@qumranet.com>, Ingo Molnar <mingo@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Whilst looking up what profile=sleep did, I noticed that we missed
adding docs for the most recent addition to the profiler.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 4d175c7..c0bb53e 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1396,6 +1396,7 @@ and is between 256 and 4096 characters. It is defined in the file
 			Param: <number> - step/bucket size as a power of 2 for
 				statistical time based profiling.
 			Param: "sleep" - profile D-state sleeping (millisecs)
+			Param: "kvm" - profile VM exits.
 
 	processor.max_cstate=	[HW,ACPI]
 			Limit processor to maximum C-state
-- 
http://www.codemonkey.org.uk
