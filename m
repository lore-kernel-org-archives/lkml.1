Return-Path: <linux-kernel-owner+w=401wt.eu-S1754867AbZHFLW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867AbZHFLW4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 07:22:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754581AbZHFLWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 07:22:55 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:41301 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbZHFLWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 07:22:55 -0400
X-Greylist: delayed 347 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Aug 2009 07:22:54 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=e3qMtqPglx7PL+odNoqV6R95FEfHWvh/UFQ6mu1zmKuTA86OuJL3aUzf/i9YnXkQKT
         lpK5pKUnLwwZVI1KTWktj28SfbIP5KfBgY/Uu+NpP89Ri1iKPauiAs5kOu6vVC+Gp0X4
         WauOT3lCGhGyYxfIGC0DGXzrs2yUTHVnAiCeU=
From: Vincent Pelletier <plr.vincent@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: net/r8169.c: harmless (?) dupe
Date: Thu, 6 Aug 2009 13:17:03 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.30-1-amd64; KDE/4.2.4; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908061317.03652.plr.vincent@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

I was searching for rtl8102 support state in the kernel, and reading the 
commit[1] adding support I saw this:

+#define R810X_CPCMD_QUIRK_MASK (\
+       EnableBist | \
+       Mac_dbgo_oe | \
+       Force_half_dup | \
+       Force_half_dup | \   <- dupe
+       Force_txflow_en | \
+       Cxpl_dbg_sel | \

If it is harmless by itself, wouldn't it indicate a missing Force_rxflow_en 
(as in R8168_CPCMD_QUIRK_MASK) ?
I don't have the card yet, so this is no bug report, just wondering.

[1] 2857ffb7b8913ef713533ac5783abd70a20529e4

PS: Please CC me when answering, I'm not subscribed.
-- 
Vincent Pelletier
