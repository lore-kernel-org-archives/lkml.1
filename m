Return-Path: <linux-kernel-owner+w=401wt.eu-S1763492AbYBBQUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763492AbYBBQUx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 11:20:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750851AbYBBQUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 11:20:43 -0500
Received: from hs-out-0708.google.com ([64.233.178.240]:61614 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750841AbYBBQUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 11:20:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=ZM29lVid0CY9qrhYPmQJmdCKz+1iNbsOUGoa4JEa3xLrJp26B31KvTQUads8MedfQo69VZIZ9hIDYSvCL/hwxMHD5LptlXjEC+n4JMTas70jgqvKzZc0a4G/6SgJK3mfDMP3aL+TRNVEZwO6kpdU5evCkgvl2+QFq7YDb6DZ0RE=
Message-ID: <804dabb00802020820k567bf07cg780da10a0b083e6e@mail.gmail.com>
Date: Sun, 3 Feb 2008 00:20:41 +0800
From: "Peter Teoh" <htmldeveloper@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: CONFIG_SECTION_MISMATCH is replaced by CONFIG_DEBUG_SECTION_MISMATCH?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I supposed CONFIG_SECTION_MISMATCH has been deprecated by
CONFIG_DEBUG_SECTION_MISMATCH, as I found
CONFIG_DEBUG_SECTION_MISMATCH in Makefile, Makefile.build and
Makefile.modpost, but not the former symbol.   Moreover, setting the
symbol in .config, and followed by make oldconfig will result in the
non-debug symbol disappearing, but not the debug version.   Am I
correct?

Signed-off-by: Peter Teoh <htmldeveloper@gmail.com>

--- scripts/mod/modpost.c.orig  2008-02-02 15:18:04.000000000 +0800
+++ scripts/mod/modpost.c       2008-02-02 15:18:47.000000000 +0800
@@ -1942,7 +1942,7 @@ int main(int argc, char **argv)
                        "To see additional details select \"Enable full "
                        "Section mismatch analysis\"\n"
                        "in the Kernel Hacking menu "
-                       "(CONFIG_SECTION_MISMATCH).\n", sec_mismatch_count);
+                       "(CONFIG_DEBUG_SECTION_MISMATCH).\n",
sec_mismatch_count);

        return err;
 }
