Return-Path: <linux-kernel-owner+w=401wt.eu-S1753341AbZFASlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341AbZFASlY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 14:41:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752738AbZFASlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 14:41:17 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:60660 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964AbZFASlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 14:41:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Wdrrp3tItqd6vJQuWWU3Ns8VufuCkOH/xxiXY/zEglD2ohMNME76ijUjYl845TTfDO
         tMtrnNvwaCJgIknkZdJVjeZMZatuNKF4xPaoH+AyPxM9fRAQ3VoEOdqNVcKUb3wUyi1P
         h5vtn4e2cWUp5QZMrL1rDk6i8nGtT6qJqZs/A=
MIME-Version: 1.0
Date: Mon, 1 Jun 2009 20:41:16 +0200
Message-ID: <d32c60160906011141y22299f2cwd3df46f6e26cf33d@mail.gmail.com>
Subject: [PATCH] Update security bugs policy in Documentation/SecurityBugs
From: Linus Turdvals <turdvals@gmail.com>
To: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Cc: rdunlap@xenotime.net, security@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates the security bugs handling policy in
Documentation/SecurityBugs, to match with the current practices
and philosophy of the Linux kernel security team.

Please apply to avoid the masturbating monkeys in the security
circus from reporting misleading bugs with no security impact
whatsoever.

Signed-off-by: Linus Turdvalds <turdvals@gmail.com>

--- tricky/Documentation/SecurityBugs
+++ honest/Documentation/SecurityBugs
@@ -1,7 +1,20 @@
 Linux kernel developers take security very seriously.  As such, we'd
 like to know when a security bug is found so that it can be fixed and
-disclosed as quickly as possible.  Please report security bugs to the
-Linux kernel security team.
+disclosed as quickly as possible.
+
+Unfortunately, since we do not believe in security bugs, your report
+could be classified as a reliability or performance problem. In such
+cases we will still fix the issue, but no specific disclosure will
+follow. Shall the reporter feel tempted to find references to said
+fix, he will require substantial amounts of time to walk through
+the commit logs in the affected git tree.
+
+Please report security bugs to the Linux kernel security team. We
+will provide the information to select members of the vendor-sec
+mailing list and Red Hat employees. The Linux kernel security team
+does not take any responsibility if said information is leaked or
+made available to third-parties through insecure communication
+channels.

 1) Contact

@@ -11,28 +24,46 @@ who will help verify the bug report and
 It is possible that the security team will bring in extra help from
 area maintainers to understand and fix the security vulnerability.

+The Linux kernel security team does not have a PGP public key at
+the moment, since information wants to be free.
+
 As it is with any bug, the more information provided the easier it
 will be to diagnose and fix.  Please review the procedure outlined in
 REPORTING-BUGS if you are unclear about what information is helpful.
 Any exploit code is very helpful and will not be released without
 consent from the reporter unless it has already been made public.
+Please do not send us binary-only exploit code, because we have no
+idea about how to unpack it.

 2) Disclosure

 The goal of the Linux kernel security team is to work with the
 bug submitter to bug resolution as well as disclosure.  We prefer
-to fully disclose the bug as soon as possible.  It is reasonable to
+to _not_ disclose the bug as soon as possible.  It is reasonable to
 delay disclosure when the bug or the fix is not yet fully understood,
-the solution is not well-tested or for vendor coordination.  However, we
-expect these delays to be short, measurable in days, not weeks or months.
+the solution is not well-tested, for vendor coordination or any other
+reason the team finds compelling, without any explanation required.
+However, we expect these delays to be short, measurable in days,
+not weeks or months. Please note that the vulnerability window might be
+measurable in years if the issue went unnoticed for such amounts of time.
 A disclosure date is negotiated by the security team working with the
 bug submitter as well as vendors.  However, the kernel security team
-holds the final say when setting a disclosure date.  The timeframe for
+holds the final say when setting a disclosure date. Once you report a
+security bug to the team, you lose all rights to the process and who
+will manage or have access to the information. The timeframe for
 disclosure is from immediate (esp. if it's already publically known)
 to a few weeks.  As a basic default policy, we expect report date to
-disclosure date to be on the order of 7 days.
+disclosure date to be on the order of 30 days.

 3) Non-disclosure agreements

 The Linux kernel security team is not a formal body and therefore unable
 to enter any non-disclosure agreements.
+
+4) Enforcement of these terms
+
+The Linux kernel security team can absolutely ignore the terms herein,
+without explanations required. This document does not provide legally
+enforceable terms by any means, nor necessarily expresses the practices
+and philosophy of the current security team.
+
