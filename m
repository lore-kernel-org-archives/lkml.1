Return-Path: <linux-kernel-owner+w=401wt.eu-S1758665AbXJQFQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758665AbXJQFQ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 01:16:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751218AbXJQFQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 01:16:49 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:47577 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbXJQFQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 01:16:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=XHi7VE+nSDkE4X6O9JcdDbmCYIcT6cvcpp5Bte/XQIjeJfqMtE9QXC2LqS8xT0kIYlcrh/NFyv6KkfQK4CYIQB1cH1kU4/+34TNjrxsLEEp3NbMdr39QyrXOQEYmvbqhHM01Fehgm0kUGNTBbVOpyO53uiUF0LCHZ2TEC6Kqfu4=
Message-ID: <f9d2a5e10710162216s149c16a3j9bb63d60fdf1e782@mail.gmail.com>
Date: Tue, 16 Oct 2007 22:16:47 -0700
From: "Russ Dill" <russ.dill@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Better document profile=
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Be more explicit on what the step/bucket size accomplishes.

Signed-off-by: Russ Dill <Russ.Dill@gmail.com>
---
 Documentation/kernel-parameters.txt |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/Documentation/kernel-parameters.txt
b/Documentation/kernel-parameters.txt
index eb24799..3c6fd27 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1427,7 +1427,10 @@ and is between 256 and 4096 characters. It is
defined in the file
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
