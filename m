Return-Path: <linux-kernel-owner+w=401wt.eu-S1758569AbYANWbM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758569AbYANWbM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 17:31:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758533AbYANW3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 17:29:09 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:22565 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754012AbYANW3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 17:29:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=WgicjT0IgfsjIwbsAMNyamX2OGJ9Wkyv0QcNLyps1HMoTVhZjjo1vVQ9RkPgbKmGd9qhqZErZ0mUw6BukWOsoIusUApwkHi1gU5Kv+H3aYyrzshn1klSZ6ml/HKvMFhRw6gpQUKhuQ9vHF/eE1VO0U8iKGpJHt7mw9teER3zmDk=
Date: Mon, 14 Jan 2008 23:29:13 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: apw@shadowen.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] Change a WARN message in checkpatch
Message-ID: <20080114232913.2555d392@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,
When I started using checkpatch I was confused by the following WARN message:

	no space between function name and open parenthesis

I thought the problem was that a space was missing while the truth is the opposite.

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
