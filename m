Return-Path: <linux-kernel-owner+w=401wt.eu-S1754053AbYHKWid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053AbYHKWid (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 18:38:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753182AbYHKWiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 18:38:23 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:15722 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968AbYHKWiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 18:38:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=knpEx8Ow6ouP5Vr+D/CkR8Ho9CAsp0RjK/DMMr2IUomUWY0ruIUEkxhdQ0BnvAzs/I
         INy9w0yIQ27FoJcShAu1HPbcmc7/3j2OVSOf7LS0fxhbEZZ42TRQR3BX5P3Vy5f/XEr6
         Huh9mKSmYHtri6NWc0Ck4kpYyHpEgLXcUrpUE=
Message-ID: <48A0BF59.4050605@gmail.com>
Date: Mon, 11 Aug 2008 18:38:17 -0400
From: Ryan Hope <rmh3093@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080805)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
       Reiserfs mailing list <reiserfs-devel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Edward Shishkin <edward.shishkin@gmail.com>
Subject: [PATCH 2/3][reiser4] don't leave loop prematurely
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was item #9 on the todo list for reiser4 inclusion in mainline:

diff --git a/52d76fde71070a6c4c8c581dd2bfe3c6ffa82ad7:fs/reiser4/page_cache.c 
b/7f1ee1bb0c5a2948f5347646795afd088da30eaf:fs/reiser4/page_cache.c
index 
edf0911dc8bb61398374ecf4f849aa30753fb274..fe713681b73d2a6c4214f5938f21794573d8607d 
100644
--- a/52d76fde71070a6c4c8c581dd2bfe3c6ffa82ad7:fs/reiser4/page_cache.c
+++ b/7f1ee1bb0c5a2948f5347646795afd088da30eaf:fs/reiser4/page_cache.c
@@ -658,8 +658,7 @@ truncate_jnodes_range(struct inode *inode, pgoff_t from, 
pgoff_t count)
  				unhash_unformatted_jnode(node);
  				truncated_jnodes++;
  				jput(node);
-			} else
-				break;
+			}
  		}
  		if (i != taken || taken == 0)
  			break;


-Ryan
