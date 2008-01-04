Return-Path: <linux-kernel-owner+w=401wt.eu-S1753735AbYADMpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735AbYADMpx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 07:45:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752215AbYADMpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 07:45:42 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:13980 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbYADMpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 07:45:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=Cls8tkpwdKp+qyF3wpnA3qpUiNMG0ZLe1sntov1GBVQkCxkDVyes5z47M2peFP4YOc1FZhwVolG/sIOqPS1qV8XWEMCiFJ9egY8bMgsnYcK09mdf/dahdTSHI3eATDFD0KgLbLhKf4eUh9vVyWpOjoskvOpXKpJ+wkigN9dBkyA=
Date: Fri, 4 Jan 2008 13:45:35 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: andyw@uk.ibm.com, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] Change a WARN message in checkpatch
Message-ID: <20080104134535.6689872a@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,
I just started using checkpatch and I was confused by the following WARN message:

	no space between function name and open parenthesis

I thought the probelm was that a space was missing while the truth is the opposite.

How about the following patch?


--- checkpatch.pl.old	2008-01-04 13:37:51.000000000 +0100
+++ checkpatch.pl	2008-01-04 13:37:24.000000000 +0100
@@ -1117,7 +1117,7 @@
 		while ($line =~ /($Ident)\s+\(/g) {
 			if ($1 !~ /^(?:if|for|while|switch|return|volatile|__volatile__|__attribute__|format|__extension__|Copyright|case)$/ &&
 		            $line !~ /$Type\s+\(/ && $line !~ /^.\#\s*define\b/) {
-				WARN("no space between function name and open parenthesis '('\n" . $herecurr);
+				WARN("don't put a space between function name and open parenthesis '('\n" . $herecurr);
 			}
 		}
 # Check operator spacing.
