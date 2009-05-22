Return-Path: <linux-kernel-owner+w=401wt.eu-S1753644AbZEVHFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644AbZEVHFc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 03:05:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751524AbZEVHFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 03:05:25 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:43248 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbZEVHFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 03:05:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:user-agent:x-face:cc:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :message-id;
        b=E6Wk9TI5ay/uOynqOMmu/QgM2X6etA+uJ/+KsyiFHiK0SQ/5i0hkSsK6gJPI12gvC3
         oXD9bUYGV2U/PKG+5f9UUwYkzAQsOPCvLhbtDOo4qhNevAOCsn/iwR53n/MAXkzAdcnz
         mdMwTHLWeAL1TezUzYwTVKrTzsC0TFAU8qCPk=
From: Jose Luis Perez Diez <jluis@escomposlinux.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH]Perl is needed to build the kernel but it is not in Documentation/Changes
Date: Fri, 22 May 2009 09:05:11 +0200
User-Agent: KMail/1.9.9
X-Face: "2E*FU(q5Y=y<[Q`"$lOX>/8Z*3f.6.tS{0@FUR%P:0AEI1(-e%(?-]KN8p!!j_26I5;)=?utf-8?q?=3F=0A=09n=26+=3D=5ElyOCVxbpJ0?=(;u*$A}%Zw([9#8=IhSg0_o/{4L6tT!*=Mx
Cc: Jose Luis Perez Diez <jluis@escomposlinux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905220905.11270.jluis@escomposlinux.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Perl is used on the kernel Makefile to generate documentation, firmwares in c
source form, sources, graphs, and some headers and this fact is undocumented.


Signed-off-by:Jose Luis Perez Diez <jluis@escomposlinux.org>

---
 Documentation/Changes |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/Documentation/Changes b/Documentation/Changes
index b95082b..6a2d53d 100644
--- a/Documentation/Changes
+++ b/Documentation/Changes
@@ -71,6 +71,13 @@ assembling the 16-bit boot code, removing the need for as86 
to compile
 your kernel.  This change does, however, mean that you need a recent
 release of binutils.
 
+Perl
+----
+
+You will need perl 5 and the following modules: Getopt::Long, Getopt::Std, 
File::Basename, and File::Find to build the kernel.
+
+
+
 System utilities
 ================
 
-- 
1.5.6.5
