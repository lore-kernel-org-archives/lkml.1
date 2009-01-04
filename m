Return-Path: <linux-kernel-owner+w=401wt.eu-S1756543AbZADKZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543AbZADKZ1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 05:25:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751181AbZADKZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 05:25:16 -0500
Received: from wf-out-1314.google.com ([209.85.200.168]:35917 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140AbZADKZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 05:25:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=Kkf1qMLgGD/+ixuT3xK24b+CtwqcHaLXqV3mJ+DCPZdF7p/rIdShOjCf05W7keF5sV
         89l27+/bVzKvWFmfT8w/SbDnmZ5q+Kmu4g3zM38q0mCZYeXhFCxVtoZqPz/LlWor1YU5
         w63wfjKwBgutxz3MnPRp7ZFdeuyguimyuKP18=
Message-ID: <d204e3110901040225n1fe7accbp786c909964b94c3@mail.gmail.com>
Date: Sun, 4 Jan 2009 18:25:13 +0800
From: "Baodong Chen" <chenbdchenbd@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Documentation/x86/boot.txt:payload length was changed to payload_length(added CC Ingo)
Cc: trivial@kernel.org, "Ingo Molnar" <mingo@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Documentation/x86/boot.txt:payload length was changed to payload_length
Signed-off-by: Baodong Chen <[email]chenbdchenbd@gmail.com[email]>

---
 Documentation/x86/boot.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/x86/boot.txt b/Documentation/x86/boot.txt
index fcdc62b..7b4596a 100644
--- a/Documentation/x86/boot.txt
+++ b/Documentation/x86/boot.txt
@@ -44,7 +44,7 @@ Protocol 2.07:	(Kernel 2.6.24) Added paravirtualised
boot protocol.
		and KEEP_SEGMENTS flag in load_flags.

 Protocol 2.08:	(Kernel 2.6.26) Added crc32 checksum and ELF format
-		payload. Introduced payload_offset and payload length
+		payload. Introduced payload_offset and payload_length
		fields to aid in locating the payload.

 Protocol 2.09:	(Kernel 2.6.26) Added a field of 64-bit physical
--
1.5.3.3
