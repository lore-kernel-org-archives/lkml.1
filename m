Return-Path: <linux-kernel-owner+w=401wt.eu-S934106AbXJQF5D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934106AbXJQF5D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 01:57:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764237AbXJQF4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 01:56:16 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:60072 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933217AbXJQF4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 01:56:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:to:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding:from;
        b=o2j4x0VHtxyx3eRQcXu8c3ixP6Vn5faC8FB36dO8ClJlQAS37i67cl2FMz8aPT2GFlkv/DL+QcRh2fLfNhSGTKT+cLov4GWDFiYMfg3/Ycc5KYdV98Zfx620XuKtGppTUpDbjVq8Ic3g1uhhQ9sl192ltK8NX7OnRWL9hRhiykU=
Subject: [PATCH fixed] Better document profile=
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Tue, 16 Oct 2007 22:55:32 -0700
Message-Id: <1192600532.25941.3.camel@russ-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
From: Russ Dill <russ.dill@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Be more explicit on what the step/bucket size accomplishes.

Signed-off-by: Russ Dill <Russ.Dill@gmail.com>
---
 Documentation/kernel-parameters.txt |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index eb24799..3c6fd27 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1427,7 +1427,10 @@ and is between 256 and 4096 characters. It is defined in the file
 			Format: [schedule,]<number>
 			Param: "schedule" - profile schedule points.
 			Param: <number> - step/bucket size as a power of 2 for
-				statistical time based profiling.
+				statistical time based profiling. A value of
+				2 will provide a granularity of 4 bytes, a
+				value of 3 will provide a granularity of 8
+				bytes and so on.
 			Param: "sleep" - profile D-state sleeping (millisecs)
 
 	processor.max_cstate=	[HW,ACPI]
-- 
1.5.2.5



