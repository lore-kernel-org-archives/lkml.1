Return-Path: <linux-kernel-owner+w=401wt.eu-S1762072AbYBBHyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762072AbYBBHyo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 02:54:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756699AbYBBHyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 02:54:37 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:5508 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756646AbYBBHyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 02:54:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=xNCkWOo6d9qFjEcUI02vu7l6Ufr2/g9S8nd8HpUA9lH3W1/PvbwhyzYj3b/bRlj0KMHE93iBy8eypS/s2yKh1H1p3ssxRhWC8ix64eq5GVxrD1FzxsOjxcxga00JHSwiQJdPLTqjLZPZY/oS3/OQwguWSOlG68XLnY5vQEf9scY=
Message-ID: <804dabb00802012354s4d99d511gbbc80d116329433@mail.gmail.com>
Date: Sat, 2 Feb 2008 15:54:33 +0800
From: "Peter Teoh" <htmldeveloper@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: CONFIG_SECTION_MISMATCH is replaced by CONFIG_DEBUG_SECTION_MISMATCH
In-Reply-To: <804dabb00802012328y58904d27v90e12e2614550d11@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <804dabb00802012328y58904d27v90e12e2614550d11@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_SECTION_MISMATCH I supposed has been deprecated by
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
