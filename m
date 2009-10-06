Return-Path: <linux-kernel-owner+w=401wt.eu-S932822AbZJFOlN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932822AbZJFOlN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 10:41:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932754AbZJFOlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 10:41:12 -0400
Received: from smtp-noauth7.primus.ca ([216.254.180.38]:34274 "EHLO
	mail-05.primus.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932707AbZJFOlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 10:41:12 -0400
X-Greylist: delayed 1691 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Oct 2009 10:41:12 EDT
Date: Tue, 6 Oct 2009 10:12:22 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH trivial] docs: Describe the 'C' taint flag in
 oops-tracing.txt.
Message-ID: <20091006141222.GA18579@emergent.ellipticsemi.com>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Bowler <nbowler@elliptictech.com>

If some of the flags are documented there, they all should be.

Signed-off-by: Nick Bowler <nbowler@elliptictech.com>
---
 Documentation/oops-tracing.txt |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/Documentation/oops-tracing.txt b/Documentation/oops-tracing.txt
index b152e81..c10c022 100644
--- a/Documentation/oops-tracing.txt
+++ b/Documentation/oops-tracing.txt
@@ -257,6 +257,8 @@ characters, each representing a particular tainted value.
 
  10: 'W' if a warning has previously been issued by the kernel.
 
+ 11: 'C' if a staging driver has been loaded.
+
 The primary reason for the 'Tainted: ' string is to tell kernel
 debuggers if this is a clean kernel or if anything unusual has
 occurred.  Tainting is permanent: even if an offending module is
-- 
1.6.4.4

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)

